//
//  FriendshipSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import Foundation

final class FriendshipSingleResponse: Identifiable, Sendable {
  let id: Int
  let user: FilmatchUserResponse

  init(id: Int, user: FilmatchUserResponse) {
    self.id = id
    self.user = user
  }
}

extension FriendshipSingleResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case id = "id"
    case user = "user"
  }

  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let id = try container.decode(Int.self, forKey: .id)
    let user = try container.decode(FilmatchUserResponse.self, forKey: .user)

    self.init(id: id, user: user)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(self.id, forKey: .id)
    try container.encode(self.user, forKey: .user)
  }
}
