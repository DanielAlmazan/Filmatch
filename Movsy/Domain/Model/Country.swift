//
//  Country.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

final class Country: Codable, Sendable {
    let iso_3166_1: String
    let name: String
    
    init(iso_3166_1: String, name: String) {
        self.iso_3166_1 = iso_3166_1
        self.name = name
    }
}

extension Country {
    enum CodingKeys: String, CodingKey {
        case iso_3166_1
        case name
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let iso_3166_1 = try container.decode(String.self, forKey: .iso_3166_1)
        let name = try container.decode(String.self, forKey: .name)

        self.init(iso_3166_1: iso_3166_1, name: name)
    }
}

extension Country {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(iso_3166_1, forKey: .iso_3166_1)
        try container.encode(name, forKey: .name)
    }
}
