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
