//
//  Mappers.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/1/25.
//

import Foundation

extension DiscoverMoviesItemSingleResponse {
  func toDiscoverMovieItem() -> DiscoverMovieItem {
    .init(adult: self.adult,
          backdropPath: self.backdropPath,
          genreIds: self.genreIds,
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
          genreIds: self.genreIds,
          id: self.id,
          name: self.name,
          originCountry: self.originCountry,
          originalLanguage: self.originalLanguage,
          originalName: self.originalName,
          overview: self.overview,
          popularity: self.popularity,
          posterPath: self.posterPath,
          voteAverage: self.voteAverage,
          voteCount: self.voteCount)
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
  func toFilmatchUser() -> FilmatchUser {
    .init(
      email: nil,
      username: self.user.username,
      uid: self.user.uid,
      photoUrl: self.user.photoUrl,
      friendshipStatus: self.user.friendshipStatus
    )
  }
}

extension [FriendshipSingleResponse] {
  func toFilmatchUsers() -> [FilmatchUser] {
    self.map { $0.toFilmatchUser() }
  }
}

extension [FilmatchUserResponse] {
  func toFilmatchUsers() -> [FilmatchUser] {
    self.map { $0.toFilmatchUser() }
  }
}

extension FilmatchUserResponse {
  func toFilmatchUser() -> FilmatchUser {
    .init(
      email: self.email ?? "",
      username: self.username,
      uid: self.uid,
      photoUrl: self.photoUrl ?? "",
      friendshipStatus: self.friendshipStatus
    )
  }
}
