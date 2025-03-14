//
//  MovieMatchSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 14/3/25.
//

import Foundation

final class MovieMatchSingleResponse {
  let isSuperMatch: Bool
  let movie: [DiscoverMoviesItemSingleResponse]
  
  init(isSuperMatch: Bool, movie: [DiscoverMoviesItemSingleResponse]) {
    self.isSuperMatch = isSuperMatch
    self.movie = movie
  }
}

extension MovieMatchSingleResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case isSuperMatch = "super_match"
    case movie
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let isSuperMatch = try container.decode(Bool.self, forKey: .isSuperMatch)
    let movie = try container.decode([DiscoverMoviesItemSingleResponse].self, forKey: .movie)

    self.init(isSuperMatch: isSuperMatch, movie: movie)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(isSuperMatch, forKey: .isSuperMatch)
    try container.encode(movie, forKey: .movie)
  }
}
