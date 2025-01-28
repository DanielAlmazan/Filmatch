//
//  TvSeriesEpisode.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 9/1/25.
//

import Foundation

final class TvSeriesEpisode: Identifiable, Sendable {
  let id: Int
  let name: String
  let overview: String
  let voteAverage: Double
  let voteCount: Int
  let airDate: Date?
  let episodeNumber: Int?
  let productionCode: String?
  let runtime: Int?
  let seasonNumber: Int?
  let showId: Int
  let stillPath: String?
  
  init(id: Int, name: String, overview: String, voteAverage: Double, voteCount: Int, airDate: Date?, episodeNumber: Int?, productionCode: String?, runtime: Int?, seasonNumber: Int?, showId: Int, stillPath: String?) {
    self.id = id
    self.name = name
    self.overview = overview
    self.voteAverage = voteAverage
    self.voteCount = voteCount
    self.airDate = airDate
    self.episodeNumber = episodeNumber
    self.productionCode = productionCode
    self.runtime = runtime
    self.seasonNumber = seasonNumber
    self.showId = showId
    self.stillPath = stillPath
  }
}

extension TvSeriesEpisode: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case overview
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case airDate = "air_date"
    case episodeNumber = "episode_number"
    case productionCode = "production_code"
    case runtime
    case seasonNumber = "season_number"
    case showId = "show_id"
    case stillPath = "still_path"
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let id = try container.decode(Int.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)
    let overview = try container.decode(String.self, forKey: .overview)
    let voteAverage = try container.decode(Double.self, forKey: .voteAverage)
    let voteCount = try container.decode(Int.self, forKey: .voteCount)
    
    let airDateString = try container.decode(String?.self, forKey: .airDate)
    let airDate: Date? = {
      guard let dateStr = airDateString, !dateStr.isEmpty else { return nil }
      return Utilities.dateFormatter.date(from: dateStr)
    }()
    
    let episodeNumber = try container.decode(Int?.self, forKey: .episodeNumber)
    let productionCode = try container.decode(String?.self, forKey: .productionCode)
    let runtime = try container.decode(Int?.self, forKey: .runtime)
    let seasonNumber = try container.decode(Int?.self, forKey: .seasonNumber)
    let showId = try container.decode(Int.self, forKey: .showId)
    let stillPath = try container.decode(String?.self, forKey: .stillPath)
    
    self.init(id: id,
              name: name,
              overview: overview,
              voteAverage: voteAverage,
              voteCount: voteCount,
              airDate: airDate,
              episodeNumber: episodeNumber,
              productionCode: productionCode,
              runtime: runtime,
              seasonNumber: seasonNumber,
              showId: showId,
              stillPath: stillPath)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(overview, forKey: .overview)
    try container.encode(voteAverage, forKey: .voteAverage)
    try container.encode(voteCount, forKey: .voteCount)
    try container.encode(airDate, forKey: .airDate)
    try container.encode(episodeNumber, forKey: .episodeNumber)
    try container.encode(productionCode, forKey: .productionCode)
    try container.encode(runtime, forKey: .runtime)
    try container.encode(seasonNumber, forKey: .seasonNumber)
    try container.encode(showId, forKey: .showId)
    try container.encode(stillPath, forKey: .stillPath)
  }
}

extension TvSeriesEpisode: Equatable {
  public static func == (lhs: TvSeriesEpisode, rhs: TvSeriesEpisode) -> Bool {
    lhs.id == rhs.id
  }
}
