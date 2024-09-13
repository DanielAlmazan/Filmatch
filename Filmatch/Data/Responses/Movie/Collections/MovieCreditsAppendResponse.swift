//
//  MovieCreditsAppendResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/9/24.
//

import Foundation

final class MovieCreditsAppendResponse: Codable {
    let cast: [CastMember]?
    let crew: [CrewMember]?
    
    init(cast: [CastMember]?, crew: [CrewMember]?) {
        self.cast = cast
        self.crew = crew
    }
}

extension MovieCreditsAppendResponse {
    enum CodingKeys: String, CodingKey {
        case cast, crew
    }
    
    convenience init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let cast = try container.decodeIfPresent([CastMember].self, forKey: .cast)
        let crew = try container.decodeIfPresent([CrewMember].self, forKey: .crew)
        
        self.init(cast: cast, crew: crew)
    }
}

extension MovieCreditsAppendResponse {
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(cast, forKey: .cast)
        try container.encodeIfPresent(crew, forKey: .crew)
    }
}
