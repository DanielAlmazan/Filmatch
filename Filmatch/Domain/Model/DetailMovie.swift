//
//  DetailMovie.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/1/25.
//

import Foundation

struct DetailMovie: DetailItem {
  let adult: Bool
  let backdropPath: String?
  let belongsToCollection: MovieCollectionSingleResponse?
  let budget: Int?
  let genres: [Genre]
  let homepage: String?
  let id: Int
  let imdbId: String?
  let originCountry: [String]
  let originalLanguage: String?
  let originalTitle: String
  let overview: String
  let popularity: Double
  let posterPath: String?
  let productionCompanies: [ProductionCompany]
  let productionCountries: [Country]
  let releaseDate: Date?
  let revenue: Int?
  let runtime: Int?
  let spokenLanguages: [LanguageModel]
  let status: String?
  let tagline: String?
  let title: String?
  let voteAverage: Double
  let voteCount: Int
  let video: Bool
  let videos: MovieVideosAppendResponse
  let credits: MovieCreditsAppendResponse
}
