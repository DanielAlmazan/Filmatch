//
//  MoviesRemoteDatasource.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/12/24.
//

import Foundation

@MainActor
protocol MoviesRemoteDatasource {
  /// Returns movie by ID if it exists.
  func getMovie(byId id: Int) async -> Result<MovieDetailSingleResponse, Error>

  /// Gets credits from a movie
  func getMovieCredits(id: Int) async -> Result<
    PersonMovieCreditsResponse, Error
  >

  /// Returns a `Result<WatchProvidersResponse, Error>` with the providers of a specific movie
  func getProviders(forMovieId id: Int) async -> Result<
    WatchProvidersResponse, Error
  >

  /// Returns a [MovieDetailResponse] based on the providers passed.
  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async
    -> Result<DiscoverMoviesResponse, Error>

  /// Returns a [MovieDetailResponse] based on the providers passed.
  func searchMovies(_ query: String, page: Int?) async -> Result<
    MoviesSearchResponse, Error
  >

  /// Gets the videos of an specific movie
  func getVideos(byMovieId id: Int) async -> Result<MovieVideosResponse, Error>
}
