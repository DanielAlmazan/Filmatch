//
//  PersonTvSeriesCreditsAsCastMember.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 14/1/25.
//

import Foundation

final class PersonTvSeriesCreditsAsCastMember: Identifiable, Sendable {
  let adult: Bool
  let backdropPath: String?
  let genreIds: [Genre.ID]
  let id: PersonDetailSingleResponse.ID
  let originCountry: [String]?
  let originalLanguage: String?
  let originalName: String?
  let overview: String?
  let popularity: Double
  let posterPath: String?
  let firstAirDate: Date?
  let name: String?
  let voteAverage: Double?
  let voteCount: Int?
  let character: String?
  let creditId: String
  let episodeCount: Int?
  
  init(
    adult: Bool,
    backdropPath: String?,
    genreIds: [Genre.ID],
    id: Int,
    originCountry: [String]?,
    originalLanguage: String?,
    originalName: String?,
    overview: String?,
    popularity: Double,
    posterPath: String?,
    firstAirDate: Date?,
    name: String?,
    voteAverage: Double?,
    voteCount: Int?,
    character: String?,
    creditId: String,
    episodeCount: Int?
  ) {
    self.adult = adult
    self.backdropPath = backdropPath
    self.genreIds = genreIds
    self.id = id
    self.originCountry = originCountry
    self.originalLanguage = originalLanguage
    self.originalName = originalName
    self.overview = overview
    self.popularity = popularity
    self.posterPath = posterPath
    self.firstAirDate = firstAirDate
    self.name = name
    self.voteAverage = voteAverage
    self.voteCount = voteCount
    self.character = character
    self.creditId = creditId
    self.episodeCount = episodeCount
  }
  
  static let `default`: PersonTvSeriesCreditsAsCastMember = .init(
    adult: false,
    backdropPath: "/r0Q6eeN9L1ORL9QsV0Sg8ZV3vnv.jpg",
    genreIds:[
      18,
      9648,
      35
    ],
    id: 1408,
    originCountry:[
      "US"
    ],
    originalLanguage: "en",
    originalName: "House",
    overview: "Dr. Gregory House, a drug-addicted, unconventional, misanthropic medical genius, leads a team of diagnosticians at the fictional Princeton–Plainsboro Teaching Hospital in New Jersey.",
    popularity: 1462.629,
    posterPath: "/3Cz7ySOQJmqiuTdrc6CY0r65yDI.jpg",
    firstAirDate: Utilities.dateFormatter.date(from: "2017-09-13"),
    name: "House",
    voteAverage: 8.6,
    voteCount: 6682,
    character: "Eve",
    creditId: "5256ccd319c2956ff607a560",
    episodeCount: 1
  )
}

extension PersonTvSeriesCreditsAsCastMember: Codable {
  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case genreIds = "genre_ids"
    case id
    case originCountry = "origin_country"
    case originalLanguage = "original_language"
    case originalName = "original_name"
    case overview
    case popularity
    case posterPath = "poster_path"
    case firstAirDate = "first_air_date"
    case name
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case character
    case creditId = "credit_id"
    case episodeCount = "episode_count"
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let adult = try container.decode(Bool.self, forKey: .adult)
    let backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    let genreIds = try container.decode([Genre.ID].self, forKey: .genreIds)
    let id = try container.decode(Int.self, forKey: .id)
    let originCountry = try container.decodeIfPresent([String].self, forKey: .originCountry)
    let originalLanguage = try container.decodeIfPresent(String.self, forKey: .originalLanguage)
    let originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
    let overview = try container.decodeIfPresent(String.self, forKey: .overview)
    let popularity = try container.decode(Double.self, forKey: .popularity)
    let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    
    let firstAirDateString = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
    let firstAirDate: Date? = {
      guard let dateStr = firstAirDateString, !dateStr.isEmpty else { return nil }
      return Utilities.dateFormatter.date(from: dateStr)
    }()
    
    let name = try container.decodeIfPresent(String.self, forKey: .name)
    let voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
    let voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
    let character = try container.decodeIfPresent(String.self, forKey: .character)
    let creditId = try container.decode(String.self, forKey: .creditId)
    let episodeCount = try container.decodeIfPresent(Int.self, forKey: .episodeCount)
    
    self.init(adult: adult,
              backdropPath: backdropPath,
              genreIds: genreIds,
              id: id,
              originCountry: originCountry,
              originalLanguage: originalLanguage,
              originalName: originalName,
              overview: overview,
              popularity: popularity,
              posterPath: posterPath,
              firstAirDate: firstAirDate,
              name: name,
              voteAverage: voteAverage,
              voteCount: voteCount,
              character: character,
              creditId: creditId,
              episodeCount: episodeCount)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(adult, forKey: .adult)
    try container.encode(backdropPath, forKey: .backdropPath)
    try container.encode(genreIds, forKey: .genreIds)
    try container.encode(id, forKey: .id)
    try container.encode(originCountry, forKey: .originCountry)
    try container.encode(originalLanguage, forKey: .originalLanguage)
    try container.encode(originalName, forKey: .originalName)
    try container.encode(overview, forKey: .overview)
    try container.encode(popularity, forKey: .popularity)
    try container.encode(posterPath, forKey: .posterPath)
    try container.encode(firstAirDate, forKey: .firstAirDate)
    try container.encode(name, forKey: .name)
    try container.encode(voteAverage, forKey: .voteAverage)
    try container.encode(voteCount, forKey: .voteCount)
    try container.encode(character, forKey: .character)
    try container.encode(creditId, forKey: .creditId)
    try container.encode(episodeCount, forKey: .episodeCount)
  }
}

extension PersonTvSeriesCreditsAsCastMember: Equatable {
  public static func == (lhs: PersonTvSeriesCreditsAsCastMember, rhs: PersonTvSeriesCreditsAsCastMember) -> Bool {
    lhs.id == rhs.id
  }
}

extension [PersonTvSeriesCreditsAsCastMember] {
  func sortedByPopularity() -> [PersonTvSeriesCreditsAsCastMember] {
    sorted { lhs, rhs in lhs.popularity > rhs.popularity }
  }
}
