//
//  FriendMovieMatchesSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 14/3/25.
//

import Foundation

final class FriendMovieMatchesSingleResponse {
  let user: OtterMatchUserResponse
  let matches: [MovieMatchSingleResponse]
  
  init(user: OtterMatchUserResponse, matches: [MovieMatchSingleResponse]) {
    self.user = user
    self.matches = matches
  }
}

extension FriendMovieMatchesSingleResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case user, matches
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let user = try container.decode(OtterMatchUserResponse.self, forKey: .user)
    let matches = try container.decode([MovieMatchSingleResponse].self, forKey: .matches)
    
    self.init(user: user, matches: matches)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(user, forKey: .user)
    try container.encode(matches, forKey: .matches)
  }
}
