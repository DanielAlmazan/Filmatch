//
//  Mappers.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/1/25.
//

import Foundation

extension DiscoverMoviesItemSingleResponse {
  func toDiscoverMovieItem() -> DiscoverMovieItem {
    .init(adult: self.adult,
          backdropPath: self.backdropPath,
          genreIds: self.genreIds ?? [],
          id: self.id,
          originalLanguage: self.originalLanguage,
          originalTitle: self.originalTitle,
          overview: self.overview,
          popularity: self.popularity,
          posterPath: self.posterPath,
          releaseDate: self.releaseDate,
          title: self.title,
          video: self.video,
          voteAverage: self.voteAverage,
          voteCount: self.voteCount)
  }
}

extension DiscoverTvSeriesItemSingleResponse {
  func toDiscoverTvSeriesItem() -> DiscoverTvSeriesItem {
    .init(backdropPath: self.backdropPath,
          firstAirDate: self.firstAirDate,
          genreIds: self.genreIds ?? [],
          id: self.id,
          name: self.name,
          originCountry: self.originCountry ?? [],
          originalLanguage: self.originalLanguage,
          originalName: self.originalName,
          overview: self.overview,
          popularity: self.popularity,
          posterPath: self.posterPath,
          voteAverage: self.voteAverage ?? 0,
          voteCount: self.voteCount ?? 0)
  }
}

extension TvSeriesDetailSingleResponse {
  func toDetailTvSeries() -> DetailTvSeries {
    .init(adult: self.adult,
          backdropPath: self.backdropPath,
          createdBy: self.createdBy,
          episodeRunTime: self.episodeRunTime,
          firstAirDate: self.firstAirDate,
          genres: self.genres,
          homepage: self.homepage,
          id: self.id,
          inProduction: self.inProduction,
          languages: self.languages,
          lastAirDate: self.lastAirDate,
          lastEpisodeToAir: self.lastEpisodeToAir,
          name: self.name,
          nextEpisodeToAir: self.nextEpisodeToAir,
          networks: self.networks,
          numberOfEpisodes: self.numberOfEpisodes,
          numberOfSeasons: self.numberOfSeasons,
          originCountry: self.originCountry,
          originalLanguage: self.originalLanguage,
          originalName: self.originalName,
          overview: self.overview,
          popularity: self.popularity,
          posterPath: self.posterPath,
          productionCompanies: self.productionCompanies,
          productionCountries: self.productionCountries,
          seasons: self.seasons,
          spokenLanguages: self.spokenLanguages,
          status: self.status,
          tagline: self.tagline,
          type: self.type,
          voteAverage: self.voteAverage,
          voteCount: self.voteCount,
          aggregateCredits: self.aggregateCredits)
  }
}

extension MovieDetailSingleResponse {
  func toDetailMovie() -> DetailMovie {
    .init(adult: self.adult,
          backdropPath: self.backdropPath,
          belongsToCollection: self.belongsToCollection,
          budget: self.budget,
          genres: self.genres,
          homepage: self.homepage,
          id: self.id,
          imdbId: self.imdbId,
          originCountry: self.originCountry,
          originalLanguage: self.originalLanguage,
          originalTitle: self.originalTitle,
          overview: self.overview,
          popularity: self.popularity,
          posterPath: self.posterPath,
          productionCompanies: self.productionCompanies,
          productionCountries: self.productionCountries,
          releaseDate: self.releaseDate,
          revenue: self.revenue,
          runtime: self.runtime,
          spokenLanguages: self.spokenLanguages,
          status: self.status,
          tagline: self.tagline,
          title: self.title,
          voteAverage: self.voteAverage,
          voteCount: self.voteCount,
          video: self.video,
          videos: self.videos,
          credits: self.credits)
  }
}

extension [FiltersStreamingProviderSingleResponse] {
  func toUrlQueryItem(separator: QueryParamSeparator) -> URLQueryItem {
    let providers = self.map { "\($0.providerId)" }.joined(
      separator: separator.rawValue)
    
    return .init(
      name: QueryParam.withWatchProviders.rawValue, value: "\(providers)")
  }
  
  func sortByDisplayPriority() -> [FiltersStreamingProviderSingleResponse] {
    self.sorted { lhs, rhs in
      let region = "\(Locale.current.region ?? "US")"
      
      guard let lhsRegion = lhs.displayPriorities[region],
            let rhsRegion = rhs.displayPriorities[region]
      else {
        return false
      }
      
      return lhsRegion < rhsRegion
    }
  }
}

extension FiltersStreamingProviderSingleResponse {
  func toProvider() -> ProviderModel {
    .init(providerId: self.providerId,
          providerName: self.providerName,
          logoPath: self.logoPath,
          displayPriority: self.displayPriority)
  }
}

extension PersonMovieCreditsResponse {
  func toPersonMovieCredits() -> PersonMovieCredits {
    .init(cast: self.cast, crew: self.crew)
  }
}

extension FriendshipSingleResponse {
  func toOtterMatchUser(as status: FriendshipStatus? = nil) -> OtterMatchUser {
    self.user.toOtterMatchUser(as: status)
  }
}

extension OtterMatchUserResponse {
  func toOtterMatchUser(as status: FriendshipStatus? = nil) -> OtterMatchUser {
    .init(
      email: self.email ?? "",
      username: self.username,
      uid: self.uid,
      photoUrl: self.photoUrl ?? "",
      friendshipStatus: self.friendshipStatus ?? status
    )
  }
}

extension MovieMatchSingleResponse {
  func toMatch() -> Match {
    .init(
      isSuperMatch: self.isSuperMatch,
      item: self.movie.toDiscoverMovieItem(),
      status: self.status
    )
  }
}

extension TvSeriesMatchSingleResponse {
  func toMatch() -> Match {
    .init(
      isSuperMatch: self.isSuperMatch,
      item: self.tvSeries.toDiscoverTvSeriesItem(),
      status: self.status
    )
  }
}

extension FriendMovieMatchesSingleResponse {
  func toSimpleFriendMatch() -> SimpleFriendMatch {
    .init(
      user: self.user.toOtterMatchUser(as: .friend),
      matches: self.matches.toMatches())
  }
}

extension FriendTvSeriesMatchesSingleResponse {
  func toSimpleFriendMatch() -> SimpleFriendMatch {
    .init(
      user: self.user.toOtterMatchUser(as: .friend),
      matches: self.matches.toMatches())
  }
}

// MARK: - Array extensions

extension Array where Element == FriendshipSingleResponse {
  func toOtterMatchUsers(as status: FriendshipStatus? = .notRelated) -> [OtterMatchUser] {
    self.map { $0.toOtterMatchUser(as: status) }
  }
}

extension Array where Element == OtterMatchUserResponse {
  func toOtterMatchUsers(as status: FriendshipStatus = .notRelated) -> [OtterMatchUser] {
    self.map { $0.toOtterMatchUser(as: status) }
  }
}

extension Array where Element == DiscoverMoviesItemSingleResponse {
  func toDiscoverMovieItems() -> [DiscoverMovieItem] {
    self.map { $0.toDiscoverMovieItem() }
  }
}

extension Array where Element == DiscoverTvSeriesItemSingleResponse {
  func toDiscoverTvSeriesItems() -> [DiscoverTvSeriesItem] {
    self.map { $0.toDiscoverTvSeriesItem() }
  }
}

extension Array where Element == MovieMatchSingleResponse {
  func toMatches() -> [Match] {
    self.map { $0.toMatch() }
  }
}

extension Array where Element == TvSeriesMatchSingleResponse {
  func toMatches() -> [Match] {
    self.map { $0.toMatch() }
  }
}

extension Array where Element == FilmatchGoQueryParam {
  var urlQueryItems: [URLQueryItem] {
    map(\.value)
  }
}

extension Array where Element == FriendMovieMatchesSingleResponse {
  func toSimpleFriendMatches() -> [SimpleFriendMatch] {
    self.map { $0.toSimpleFriendMatch() }
  }
}

extension Array where Element == FriendTvSeriesMatchesSingleResponse {
  func toSimpleFriendMatches() -> [SimpleFriendMatch] {
    self.map { $0.toSimpleFriendMatch() }
  }
}

extension Array where Element == SimpleFriendMatch {
  func toMatches() -> [Match] {
    self.flatMap { $0.matches }
  }
}

extension [SimpleFriendMatch]? {
  mutating func appendItems(_ items: [SimpleFriendMatch]) {
    self == nil ? self = items : self!.appendUnique(contentsOf: items)
  }

  mutating func appendItems(_ items: [FriendMovieMatchesSingleResponse]) {
    self == nil ? self = items.toSimpleFriendMatches() : self!.appendUnique(contentsOf: items.toSimpleFriendMatches())
  }

  mutating func appendItems(_ items: [FriendTvSeriesMatchesSingleResponse]) {
    self == nil ? self = items.toSimpleFriendMatches() : self!.appendUnique(contentsOf: items.toSimpleFriendMatches())
  }
}

extension [Match]? {
  mutating func appendItems(_ items: [MovieMatchSingleResponse]) {
    self == nil ? self = items.toMatches() : self!.appendUnique(contentsOf: items.toMatches())
  }

  mutating func appendItems(_ items: [TvSeriesMatchSingleResponse]) {
    self == nil ? self = items.toMatches() : self!.appendUnique(contentsOf: items.toMatches())
  }
}

extension Array where Element: Equatable {
  mutating func appendUnique(contentsOf newElements: [Element]) {
    for element in newElements {
      if !self.contains(element) {
        self.append(element)
      }
    }
  }
}
