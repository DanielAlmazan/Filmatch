//
//  DiscoverTvSeriesItemSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class DiscoverTvSeriesItemSingleResponse: Identifiable, Sendable {
  let backdropPath: String?
  let firstAirDate: Date?
  let genreIds: [Int]
  let id: Int
  let name: String
  let originCountry: [String]
  let originalLanguage: String?
  let originalName: String?
  let overview: String?
  let popularity: Double
  let posterPath: String?
  let voteAverage: Double
  let voteCount: Int
  
  init(backdropPath: String?,
       firstAirDate: Date?,
       genreIds: [Int],
       id: Int,
       name: String,
       originCountry: [String],
       originalLanguage: String?,
       originalName: String?,
       overview: String?,
       popularity: Double,
       posterPath: String?,
       voteAverage: Double,
       voteCount: Int
  ) {
    self.backdropPath = backdropPath
    self.firstAirDate = firstAirDate
    self.genreIds = genreIds
    self.id = id
    self.name = name
    self.originCountry = originCountry
    self.originalLanguage = originalLanguage
    self.originalName = originalName
    self.overview = overview
    self.popularity = popularity
    self.posterPath = posterPath
    self.voteAverage = voteAverage
    self.voteCount = voteCount
  }
}

extension DiscoverTvSeriesItemSingleResponse: Codable {
  enum CodingKeys: String, CodingKey {
    case id, name, overview, popularity
    case backdropPath = "backdrop_path"
    case firstAirDate = "first_air_date"
    case genreIds = "genre_ids"
    case originCountry = "origin_country"
    case originalLanguage = "original_language"
    case originalName = "original_name"
    case posterPath = "poster_path"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
  
  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    
    let firstAirDateString = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
    let firstAirDate: Date? = {
      guard let dateStr = firstAirDateString, !dateStr.isEmpty else { return nil }
      
      return Utilities.dateFormatter.date(from: dateStr)
    }()

    let genreIds = try container.decode([Int].self, forKey: .genreIds)
    let id = try container.decode(Int.self, forKey: .id)
    let name = try container.decode(String.self, forKey: .name)
    let originCountry = try container.decode([String].self, forKey: .originCountry)
    let originalLanguage = try container.decode(String?.self, forKey: .originalLanguage)
    let originalName = try container.decode(String?.self, forKey: .originalName)
    let overview = try container.decode(String?.self, forKey: .overview)
    let popularity = try container.decode(Double.self, forKey: .popularity)
    let posterPath = try container.decode(String?.self, forKey: .posterPath)
    let voteAverage = try container.decode(Double.self, forKey: .voteAverage)
    let voteCount = try container.decode(Int.self, forKey: .voteCount)
    
    self.init(backdropPath: backdropPath,
              firstAirDate: firstAirDate,
              genreIds: genreIds,
              id: id,
              name: name,
              originCountry: originCountry,
              originalLanguage: originalLanguage,
              originalName: originalName,
              overview: overview,
              popularity: popularity,
              posterPath: posterPath,
              voteAverage: voteAverage,
              voteCount: voteCount)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(backdropPath, forKey: .backdropPath)
    try container.encode(firstAirDate, forKey: .firstAirDate)
    try container.encode(genreIds, forKey: .genreIds)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(originCountry, forKey: .originCountry)
    try container.encode(originalLanguage, forKey: .originalLanguage)
    try container.encode(originalName, forKey: .originalName)
    try container.encode(overview, forKey: .overview)
    try container.encode(popularity, forKey: .popularity)
    try container.encode(posterPath, forKey: .posterPath)
    try container.encode(voteAverage, forKey: .voteAverage)
    try container.encode(voteCount, forKey: .voteCount)
  }
}

extension DiscoverTvSeriesItemSingleResponse: Equatable {
  static func == (lhs: DiscoverTvSeriesItemSingleResponse, rhs: DiscoverTvSeriesItemSingleResponse) -> Bool {
    lhs.backdropPath == rhs.backdropPath
    && lhs.firstAirDate == rhs.firstAirDate
    && lhs.genreIds == rhs.genreIds
    && lhs.id == rhs.id
    && lhs.name == rhs.name
    && lhs.originCountry == rhs.originCountry
    && lhs.originalLanguage == rhs.originalLanguage
    && lhs.originalName == rhs.originalName
    && lhs.overview == rhs.overview
    && lhs.popularity == rhs.popularity
    && lhs.posterPath == rhs.posterPath
    && lhs.voteAverage == rhs.voteAverage
    && lhs.voteCount == rhs.voteCount
  }
}

extension DiscoverTvSeriesItemSingleResponse: CustomStringConvertible {
  public var description: String {
    "{ Tv Series: id: \(self.id), title: \(self.name) }"
  }
}
