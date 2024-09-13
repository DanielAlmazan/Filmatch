//
//  LanguageModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

final class LanguageModel: Codable {
    let englishName: String
    let iso_3166_1: String?
    let iso_639_1: String?
    let iso_639_3: String?
    let name: String
    
    init(englishName: String, iso_3166_1: String?, iso_639_1: String?, iso_639_3: String?, name: String) {
        self.englishName = englishName
        self.iso_3166_1 = iso_3166_1
        self.iso_639_1 = iso_639_1
        self.iso_639_3 = iso_639_3
        self.name = name
    }
}

extension LanguageModel {
    enum CodingKeys: String, CodingKey {
        case iso_3166_1,
             iso_639_1,
             iso_639_3,
             name
        case englishName = "english_name"
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let englishName = try container.decode(String.self, forKey: .englishName)
        let iso_3166_1 = try container.decodeIfPresent(String.self, forKey: .iso_3166_1)
        let iso_639_1 = try container.decodeIfPresent(String.self, forKey: .iso_639_1)
        let iso_639_3 = try container.decodeIfPresent(String.self, forKey: .iso_639_3)
        let name = try container.decode(String.self, forKey: .name)
        
        self.init(englishName: englishName, iso_3166_1: iso_3166_1, iso_639_1: iso_639_1, iso_639_3: iso_639_3, name: name)
    }
}

extension LanguageModel {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(englishName, forKey: .englishName)
        try container.encodeIfPresent(iso_3166_1, forKey: .iso_3166_1)
        try container.encodeIfPresent(iso_639_1, forKey: .iso_639_1)
        try container.encodeIfPresent(iso_639_3, forKey: .iso_639_3)
        try container.encode(name, forKey: .name)
    }
}
