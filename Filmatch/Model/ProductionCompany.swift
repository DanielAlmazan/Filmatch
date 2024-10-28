//
//  ProductionCompany.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

final class ProductionCompany: Codable, Sendable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String
    
    init(id: Int, logoPath: String?, name: String, originCountry: String) {
        self.id = id
        self.logoPath = logoPath
        self.name = name
        self.originCountry = originCountry
    }
}

extension ProductionCompany {
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
     
        let id = try container.decode(Int.self, forKey: .id)
        let logoPath = try container.decode(String?.self, forKey: .logoPath)
        let name = try container.decode(String.self, forKey: .name)
        let originCountry = try container.decode(String.self, forKey: .originCountry)
        
        self.init(id: id, logoPath: logoPath, name: name, originCountry: originCountry)
    }
}

extension ProductionCompany {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(logoPath, forKey: .logoPath)
        try container.encode(name, forKey: .name)
        try container.encode(originCountry, forKey: .originCountry)
        
    }
}
