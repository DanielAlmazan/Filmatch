//
//  Video.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import Foundation

final class Video: Identifiable, Codable {
    let id: String
    let iso_639_1: String
    let iso_3166_1: String
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    
    init(id: String, iso_639_1: String, iso_3166_1: String, name: String, key: String, site: String, size: Int, type: String, official: Bool, publishedAt: String) {
        self.id = id
        self.iso_639_1 = iso_639_1
        self.iso_3166_1 = iso_3166_1
        self.name = name
        self.key = key
        self.site = site
        self.size = size
        self.type = type
        self.official = official
        self.publishedAt = publishedAt
    }
    
    static let `default` = Video(id: "66c1e1ec5e9a3e09069232a1", iso_639_1: "en", iso_3166_1: "US", name: "Evolves", key: "4ySnTIPl7fg", site: "YouTube", size: 1080, type: "Teaser", official: true, publishedAt: "2024-08-18T04:00:03.000Z")
}

extension Video {
    enum CodingKeys: String, CodingKey {
        case id
        case iso_639_1
        case iso_3166_1
        case name
        case key
        case site
        case size
        case type
        case official
        case publishedAt = "published_at"
    }
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(String.self, forKey: .id)
        let iso_639_1 = try container.decode(String.self, forKey: .iso_639_1)
        let iso_3166_1 = try container.decode(String.self, forKey: .iso_3166_1)
        let name = try container.decode(String.self, forKey: .name)
        let key = try container.decode(String.self, forKey: .key)
        let site = try container.decode(String.self, forKey: .site)
        let size = try container.decode(Int.self, forKey: .size)
        let type = try container.decode(String.self, forKey: .type)
        let official = try container.decode(Bool.self, forKey: .official)
        let publishedAt = try container.decode(String.self, forKey: .publishedAt)
        
        self.init(id: id, iso_639_1: iso_639_1, iso_3166_1: iso_3166_1, name: name, key: key, site: site, size: size, type: type, official: official, publishedAt: publishedAt)
    }
}

extension Video {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(iso_639_1, forKey: .iso_639_1)
        try container.encode(iso_3166_1, forKey: .iso_3166_1)
        try container.encode(name, forKey: .name)
        try container.encode(key, forKey: .key)
        try container.encode(site, forKey: .site)
        try container.encode(size, forKey: .size)
        try container.encode(type, forKey: .type)
        try container.encode(official, forKey: .official)
        try container.encode(publishedAt, forKey: .publishedAt)
    }
}
