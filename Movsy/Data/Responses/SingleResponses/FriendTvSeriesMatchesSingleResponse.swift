//
//  FriendTvSeriesMatchesSingleResponse.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 14/3/25.
//

import Foundation

final class FriendTvSeriesMatchesSingleResponse: Sendable {
  let user: MovsyUserResponse
  let matches: [TvSeriesMatchSingleResponse]
  
  init(user: MovsyUserResponse, matches: [TvSeriesMatchSingleResponse]) {
    self.user = user
    self.matches = matches
  }
}

extension FriendTvSeriesMatchesSingleResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case user, matches
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let user = try container.decode(MovsyUserResponse.self, forKey: .user)
    let matches = try container.decode([TvSeriesMatchSingleResponse].self, forKey: .matches)
    
    self.init(user: user, matches: matches)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(user, forKey: .user)
    try container.encode(matches, forKey: .matches)
  }
}
