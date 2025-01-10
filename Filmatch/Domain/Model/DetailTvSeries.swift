//
//  DetailTvSeries.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/1/25.
//

import Foundation

struct DetailTvSeries: DetailItem {
  let adult: Bool
  let backdropPath: String?
  let createdBy: [Creator]
  let episodeRunTime: [Int]
  let firstAirDate: Date?
  let genres: [Genre]
  let homepage: String?
  let id: Int
  let inProduction: Bool
  let languages: [String]
  let lastAirDate: Date?
  let lastEpisodeToAir: TvSeriesEpisode?
  let name: String?
  let nextEpisodeToAir: TvSeriesEpisode?
  let networks: [NetworkModel]
  let numberOfEpisodes: Int
  let numberOfSeasons: Int
  let originCountry: [String]
  let originalLanguage: String?
  let originalName: String?
  let overview: String
  let popularity: Double
  let posterPath: String?
  let productionCompanies: [ProductionCompany]
  let productionCountries: [Country]
  let seasons: [TvDetailSeasonSingleResponse]
  let spokenLanguages: [LanguageModel]
  let status: String?
  let tagline: String?
  let type: String?
  let voteAverage: Double
  let voteCount: Int
  let aggregateCredits: TvSeriesAggregateCreditsAppendResponse
}
