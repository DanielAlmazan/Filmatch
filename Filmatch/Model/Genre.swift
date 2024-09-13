//
//  Genre.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

final class Genre: Identifiable, Codable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension Genre {
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        
        self.init(id: id, name: name)
    }
}

extension Genre {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

extension Genre: CustomStringConvertible {
    var description: String {
        return """
            Genre:
              - id: \(id)
              - name: \(name)
            
            """
    }
}
