//
//  TvDetailSeasonSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class TvDetailSeasonSingleResponse: Identifiable, Sendable {
  let airDate: Date?
  let episodeCount: Int
  let id: Int
  let name: String
  let overview: String
  let posterPath: String?
  let seasonNumber: Int
  let voteAverage: Double
  
  init(airDate: Date?,
       episodeCount: Int,
       id: Int,
       name: String,
       overview: String,
       posterPath: String?,
       seasonNumber: Int,
       voteAverage: Double
  ) {
    self.airDate = airDate
    self.episodeCount = episodeCount
    self.id = id
    self.name = name
    self.overview = overview
    self.posterPath = posterPath
    self.seasonNumber = seasonNumber
    self.voteAverage = voteAverage
  }
}

extension TvDetailSeasonSingleResponse: Codable {
  enum CodingKeys: String, CodingKey {
    case id, name, overview
    case airDate = "air_date"
    case episodeCount = "episode_count"
    case posterPath = "poster_path"
    case seasonNumber = "season_number"
    case voteAverage = "vote_average"
  }
  
  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let airDateString = try container.decode(String?.self, forKey: .airDate)

    let airDate: Date? = {
      guard let airDateString, !airDateString.isEmpty else { return nil }
      return Utilities.dateFormatter.date(from: airDateString)
    }()

    let episodeCount = try container.decode(Int.self, forKey: .episodeCount)
    let id = try container.decode(Int.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)
    let overview = try container.decode(String.self, forKey: .overview)
    let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    let seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
    let voteAverage = try container.decode(Double.self, forKey: .voteAverage)
    
    self.init(airDate: airDate,
              episodeCount: episodeCount,
              id: id,
              name: name,
              overview: overview,
              posterPath: posterPath,
              seasonNumber: seasonNumber,
              voteAverage: voteAverage)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(airDate, forKey: .airDate)
    try container.encode(episodeCount, forKey: .episodeCount)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(overview, forKey: .overview)
    try container.encode(posterPath, forKey: .posterPath)
    try container.encode(seasonNumber, forKey: .seasonNumber)
    try container.encode(voteAverage, forKey: .voteAverage)
  }
}
