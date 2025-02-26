//
//  DiscoverTvSeriesItem.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/1/25.
//

import Foundation

struct DiscoverTvSeriesItem: DiscoverItem {
  let mediaType: MediaType = .tvSeries
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
  
  var getTitle: String {
    self.name
  }
  
  var getReleaseDate: String {
    guard let date = self.firstAirDate else { return "unknown" }
    return "\(Calendar.current.component(.year, from: date))"
  }
}

extension DiscoverTvSeriesItem: Encodable {
  private enum CodingKeys: String, CodingKey {
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
