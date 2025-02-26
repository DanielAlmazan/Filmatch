//
//  RegionModel.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/9/24.
//

import Foundation

final class RegionModel: Codable {
    let iso_3166_1: String
    let nativeName: String
    let englishName: String
    
    init(iso_3166_1: String, nativeName: String, englishName: String) {
        self.iso_3166_1 = iso_3166_1
        self.nativeName = nativeName
        self.englishName = englishName
    }
}

extension RegionModel {
    enum CodingKeys: String, CodingKey {
        case iso_3166_1
        case nativeName = "native_name"
        case englishName = "english_name"
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let iso_3166_1 = try container.decode(String.self, forKey: .iso_3166_1)
        let nativeName = try container.decode(String.self, forKey: .nativeName)
        let englishName = try container.decode(String.self, forKey: .englishName)
        
        self.init(iso_3166_1: iso_3166_1, nativeName: nativeName, englishName: englishName)
    }
}

extension RegionModel {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(iso_3166_1, forKey: .iso_3166_1)
        try container.encode(nativeName, forKey: .nativeName)
        try container.encode(englishName, forKey: .englishName)
    }
}
