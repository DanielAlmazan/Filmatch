//
//  MovieMatchSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 14/3/25.
//

import Foundation

final class MovieMatchSingleResponse: Sendable {
  let isSuperMatch: Bool
  let movie: DiscoverMoviesItemSingleResponse
  let status: InterestStatus
  
  init(isSuperMatch: Bool, movie: DiscoverMoviesItemSingleResponse, status: InterestStatus) {
    self.isSuperMatch = isSuperMatch
    self.movie = movie
    self.status = status
  }
}

extension MovieMatchSingleResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case isSuperMatch = "super_match"
    case movie
    case status
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let isSuperMatch = try container.decode(Bool.self, forKey: .isSuperMatch)
    let movie = try container.decode(DiscoverMoviesItemSingleResponse.self, forKey: .movie)
    let status = try container.decode(InterestStatus.self, forKey: .status)

    self.init(isSuperMatch: isSuperMatch, movie: movie, status: status)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(isSuperMatch, forKey: .isSuperMatch)
    try container.encode(movie, forKey: .movie)
    try container.encode(status, forKey: .status)
  }
}
