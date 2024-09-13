//
//  MovieVideosAppendResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/9/24.
//

import Foundation

final class MovieVideosAppendResponse: Codable {
    let results: [Video]?
    
    init(results: [Video]?) {
        self.results = results
    }
}

extension MovieVideosAppendResponse {
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let results = try container.decodeIfPresent([Video].self, forKey: .results)
        
        self.init(results: results)
    }
}

extension MovieVideosAppendResponse {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(results, forKey: .results)
    }
}
