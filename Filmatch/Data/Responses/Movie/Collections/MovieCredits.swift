//
//  FilmCredits.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import Foundation

final class MovieCredits: Identifiable, Codable {
    let id: Int
    let cast: [CastMember]?
    let crew: [CrewMember]?
    
    init(id: Int, cast: [CastMember]?, crew: [CrewMember]?) {
        self.id = id
        self.cast = cast
        self.crew = crew
    }

    enum CodingKeys: String, CodingKey {
        case id, cast, crew
    }
}

extension MovieCredits: CustomStringConvertible {
    var description: String {
        let castMembers = cast?.description ?? "No cast available"
        let crewMembers = crew?.description ?? "No cast available"
        return """
               MovieCredits:
                - id: \(id)
                - cast: \(castMembers)
                - crew: \(crewMembers)
               """
    }
}
