//
//  MovieVideos.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import Foundation

final class MovieVideosResponse: Identifiable, Codable {
    let id: Int
    let results: [Video]
    
    init(id: Int, results: [Video]) {
        self.id = id
        self.results = results
    }
}

extension MovieVideosResponse {
    enum CodingKeys: String, CodingKey {
        case id, results
    }
    
    convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let results = try container.decode([Video].self, forKey: .results)
        
        self.init(id: id, results: results)
    }
}

extension MovieVideosResponse {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(results, forKey: .results)
    }
}
