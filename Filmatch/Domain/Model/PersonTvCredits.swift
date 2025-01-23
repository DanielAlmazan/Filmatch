//
//  PersonTvCredits.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 14/1/25.
//

import Foundation

struct PersonTvCredits: Sendable {
  let cast: [PersonTvSeriesCreditsAsCastMember]?
  let crew: [PersonTvSeriesCreditsAsCrewMember]?
}

extension PersonTvCredits: Codable {
  enum CodingKeys: String, CodingKey {
    case cast
    case crew
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let cast = try container.decode([PersonTvSeriesCreditsAsCastMember]?.self, forKey: .cast)
    let crew = try container.decode([PersonTvSeriesCreditsAsCrewMember]?.self, forKey: .crew)
    
    self.init(cast: cast, crew: crew)
  }
}
