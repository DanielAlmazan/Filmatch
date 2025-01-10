//
//  TvSeriesCastRole.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class TvSeriesCastRole: Identifiable, Sendable {
  let creditId: String
  let character: String
  let episodeCount: Int

  init(creditId: String, character: String, episodeCount: Int) {
    self.creditId = creditId
    self.character = character
    self.episodeCount = episodeCount
  }
}

extension TvSeriesCastRole: Codable {
  enum CodingKeys: String, CodingKey {
    case creditId = "credit_id"
    case character
    case episodeCount = "episode_count"
  }

  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let id = try container.decode(String.self, forKey: .creditId)
    let character = try container.decode(String.self, forKey: .character)
    let episodeCount = try container.decode(Int.self, forKey: .episodeCount)

    self.init(creditId: id, character: character, episodeCount: episodeCount)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(creditId, forKey: .creditId)
    try container.encode(character, forKey: .character)
    try container.encode(episodeCount, forKey: .episodeCount)
  }
}

extension TvSeriesCastRole: Equatable {
  static func == (lhs: TvSeriesCastRole, rhs: TvSeriesCastRole) -> Bool {
    lhs.creditId == rhs.creditId
      && lhs.character == rhs.character
      && lhs.episodeCount == rhs.episodeCount
  }
}
