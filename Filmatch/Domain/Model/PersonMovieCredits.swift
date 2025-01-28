//
//  PersonMovieCredits.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 13/1/25.
//

import Foundation

struct PersonMovieCredits: Sendable, Codable {
  let cast: [PersonMovieCreditsAsCastMember]?
  let crew: [PersonMovieCreditsAsCrewMember]?
}
