//
//  TvSeriesDetailSingleResponse.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 4/1/25.
//

import Foundation

final class TvSeriesDetailSingleResponse: Identifiable, Sendable {
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
  let videos: MovieVideosAppendResponse

  init(adult: Bool,
       backdropPath: String?,
       createdBy: [Creator],
       episodeRunTime: [Int],
       firstAirDate: Date?,
       genres: [Genre],
       homepage: String?,
       id: Int,
       inProduction: Bool,
       languages: [String],
       lastAirDate: Date?,
       lastEpisodeToAir: TvSeriesEpisode?,
       name: String?,
       nextEpisodeToAir: TvSeriesEpisode?,
       networks: [NetworkModel],
       numberOfEpisodes: Int,
       numberOfSeasons: Int,
       originCountry: [String],
       originalLanguage: String?,
       originalName: String?,
       overview: String,
       popularity: Double,
       posterPath: String?,
       productionCompanies: [ProductionCompany],
       productionCountries: [Country],
       seasons: [TvDetailSeasonSingleResponse],
       spokenLanguages: [LanguageModel],
       status: String?,
       tagline: String?,
       type: String?,
       voteAverage: Double,
       voteCount: Int,
       aggregateCredits: TvSeriesAggregateCreditsAppendResponse,
       videos: MovieVideosAppendResponse
  ) {
    self.adult = adult
    self.backdropPath = backdropPath
    self.createdBy = createdBy
    self.episodeRunTime = episodeRunTime
    self.firstAirDate = firstAirDate
    self.genres = genres
    self.homepage = homepage
    self.id = id
    self.inProduction = inProduction
    self.languages = languages
    self.lastAirDate = lastAirDate
    self.lastEpisodeToAir = lastEpisodeToAir
    self.name = name
    self.nextEpisodeToAir = nextEpisodeToAir
    self.networks = networks
    self.numberOfEpisodes = numberOfEpisodes
    self.numberOfSeasons = numberOfSeasons
    self.originCountry = originCountry
    self.originalLanguage = originalLanguage
    self.originalName = originalName
    self.overview = overview
    self.popularity = popularity
    self.posterPath = posterPath
    self.productionCompanies = productionCompanies
    self.productionCountries = productionCountries
    self.seasons = seasons
    self.spokenLanguages = spokenLanguages
    self.status = status
    self.tagline = tagline
    self.type = type
    self.voteAverage = voteAverage
    self.voteCount = voteCount
    self.aggregateCredits = aggregateCredits
    self.videos = videos
  }
}

extension TvSeriesDetailSingleResponse: Codable {
  enum CodingKeys: String, CodingKey {
    case adult = "adult"
    case backdropPath = "backdrop_path"
    case createdBy = "created_by"
    case episodeRunTime = "episode_run_time"
    case firstAirDate = "first_air_date"
    case genres = "genres"
    case homepage = "homepage"
    case id = "id"
    case inProduction = "in_production"
    case languages = "languages"
    case lastAirDate = "last_air_date"
    case lastEpisodeToAir = "last_episode_to_air"
    case name = "name"
    case nextEpisodeToAir = "next_episode_to_air"
    case networks = "networks"
    case numberOfEpisodes = "number_of_episodes"
    case numberOfSeasons = "number_of_seasons"
    case originCountry = "origin_country"
    case originalLanguage = "original_language"
    case originalName = "original_name"
    case overview = "overview"
    case popularity = "popularity"
    case posterPath = "poster_path"
    case productionCompanies = "production_companies"
    case productionCountries = "production_countries"
    case seasons = "seasons"
    case spokenLanguages = "spoken_languages"
    case status = "status"
    case tagline = "tagline"
    case type = "type"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case aggregateCredits = "aggregate_credits"
    case videos = "videos"
  }
  
  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let adult = try container.decode(Bool.self, forKey: .adult)
    let backdropPath = try container.decode(String?.self, forKey: .backdropPath)
    let createdBy = try container.decode([Creator].self, forKey: .createdBy)
    let episodeRunTime = try container.decode([Int].self, forKey: .episodeRunTime)
    
    let firstAirDateString = try container.decode(String?.self, forKey: .firstAirDate)
    let firstAirDate: Date? = {
      guard let dateStr = firstAirDateString, !dateStr.isEmpty else { return nil }
      return Utilities.dateFormatter.date(from: dateStr)
    }()

    let genres = try container.decode([Genre].self, forKey: .genres)
    let homepage = try container.decode(String?.self, forKey: .homepage)
    let id = try container.decode(Int.self, forKey: .id)
    let inProduction = try container.decode(Bool.self, forKey: .inProduction)
    let languages = try container.decode([String].self, forKey: .languages)
    
    let lastAirDateString = try container.decode(String?.self, forKey: .lastAirDate)
    let lastAirDate: Date? = {
      guard let dateStr = lastAirDateString, !dateStr.isEmpty else { return nil }
      return Utilities.dateFormatter.date(from: dateStr)
    }()
    
    let lastEpisodeToAir = try container.decode(TvSeriesEpisode?.self, forKey: .lastEpisodeToAir)
    let name = try container.decode(String?.self, forKey: .name)
    let nextEpisodeToAir = try container.decode(TvSeriesEpisode?.self, forKey: .nextEpisodeToAir)
    let networks = try container.decode([NetworkModel].self, forKey: .networks)
    let numberOfEpisodes = try container.decode(Int.self, forKey: .numberOfEpisodes)
    let numberOfSeasons = try container.decode(Int.self, forKey: .numberOfSeasons)
    let originCountry = try container.decode([String].self, forKey: .originCountry)
    let originalLanguage = try container.decode(String?.self, forKey: .originalLanguage)
    let originalName = try container.decode(String?.self, forKey: .originalName)
    let overview = try container.decode(String.self, forKey: .overview)
    let popularity = try container.decode(Double.self, forKey: .popularity)
    let posterPath = try container.decode(String?.self, forKey: .posterPath)
    let productionCompanies = try container.decode([ProductionCompany].self, forKey: .productionCompanies)
    let productionCountries = try container.decode([Country].self, forKey: .productionCountries)
    let seasons = try container.decode([TvDetailSeasonSingleResponse].self, forKey: .seasons)
    let spokenLanguages = try container.decode([LanguageModel].self, forKey: .spokenLanguages)
    let status = try container.decode(String?.self, forKey: .status)
    let tagline = try container.decode(String?.self, forKey: .tagline)
    let type = try container.decode(String?.self, forKey: .type)
    let voteAverage = try container.decode(Double.self, forKey: .voteAverage)
    let voteCount = try container.decode(Int.self, forKey: .voteCount)
    let aggregateCredits = try container.decode(TvSeriesAggregateCreditsAppendResponse.self, forKey: .aggregateCredits)
    let videos = try container.decode(MovieVideosAppendResponse.self, forKey: .videos)

    self.init(adult: adult,
              backdropPath: backdropPath,
              createdBy: createdBy,
              episodeRunTime: episodeRunTime,
              firstAirDate: firstAirDate,
              genres: genres,
              homepage: homepage,
              id: id,
              inProduction: inProduction,
              languages: languages,
              lastAirDate: lastAirDate,
              lastEpisodeToAir: lastEpisodeToAir,
              name: name,
              nextEpisodeToAir: nextEpisodeToAir,
              networks: networks,
              numberOfEpisodes: numberOfEpisodes,
              numberOfSeasons: numberOfSeasons,
              originCountry: originCountry,
              originalLanguage: originalLanguage,
              originalName: originalName,
              overview: overview,
              popularity: popularity,
              posterPath: posterPath,
              productionCompanies: productionCompanies,
              productionCountries: productionCountries,
              seasons: seasons,
              spokenLanguages: spokenLanguages,
              status: status,
              tagline: tagline,
              type: type,
              voteAverage: voteAverage,
              voteCount: voteCount,
              aggregateCredits: aggregateCredits,
              videos: videos
    )
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(adult, forKey: .adult)
    try container.encode(backdropPath, forKey: .backdropPath)
    try container.encode(createdBy, forKey: .createdBy)
    try container.encode(episodeRunTime, forKey: .episodeRunTime)
    try container.encode(firstAirDate, forKey: .firstAirDate)
    try container.encode(genres, forKey: .genres)
    try container.encode(homepage, forKey: .homepage)
    try container.encode(id, forKey: .id)
    try container.encode(inProduction, forKey: .inProduction)
    try container.encode(languages, forKey: .languages)
    try container.encode(lastAirDate, forKey: .lastAirDate)
    try container.encode(lastEpisodeToAir, forKey: .lastEpisodeToAir)
    try container.encode(name, forKey: .name)
    try container.encode(nextEpisodeToAir, forKey: .nextEpisodeToAir)
    try container.encode(networks, forKey: .networks)
    try container.encode(numberOfEpisodes, forKey: .numberOfEpisodes)
    try container.encode(numberOfSeasons, forKey: .numberOfSeasons)
    try container.encode(originCountry, forKey: .originCountry)
    try container.encode(originalLanguage, forKey: .originalLanguage)
    try container.encode(originalName, forKey: .originalName)
    try container.encode(overview, forKey: .overview)
    try container.encode(popularity, forKey: .popularity)
    try container.encode(posterPath, forKey: .posterPath)
    try container.encode(productionCompanies, forKey: .productionCompanies)
    try container.encode(productionCountries, forKey: .productionCountries)
    try container.encode(seasons, forKey: .seasons)
    try container.encode(spokenLanguages, forKey: .spokenLanguages)
    try container.encode(status, forKey: .status)
    try container.encode(tagline, forKey: .tagline)
    try container.encode(type, forKey: .type)
    try container.encode(voteAverage, forKey: .voteAverage)
    try container.encode(voteCount, forKey: .voteCount)
    try container.encode(aggregateCredits, forKey: .aggregateCredits)
    try container.encode(videos, forKey: .videos)
  }
}

extension TvSeriesDetailSingleResponse: Equatable {
  static func == (lhs: TvSeriesDetailSingleResponse, rhs: TvSeriesDetailSingleResponse) -> Bool {
    lhs.id == rhs.id
  }
}
