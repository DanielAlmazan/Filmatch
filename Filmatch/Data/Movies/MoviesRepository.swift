//
//  MoviesRepository.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

protocol MoviesRepository {
  /// Returns movie by ID if it exists.
  func getMovie(byId id: Int) async throws -> MovieDetailSingleResponse?

  /// Gets every MovieProvider
  func getProviders() async throws -> [MovieProvider]

  /// Gets credits from a movie
  func getMovieCredits(id: Int) async throws -> MovieCredits

  /// Returns a [MovieDetailResponse] based on the providers passed.
  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async throws
    -> [DiscoverMoviesItem]

  /// Returns a [MovieDetailResponse] based on the providers passed.
  func searchMovies(
    _ query: String, includeAdult: Bool?, primaryReleaseDate: String?,
    page: Int?, region: String?, year: Int?
  ) async throws -> [MoviesSearchResponse]

  /// Gets the videos of an specific movie
  func getVideos(byMovieId id: Int) async throws -> MovieVideosResponse

  /// Gets a person by ID if exists.
  func getPerson(byId id: Int) async throws -> PersonDetailSingleResponse?
}
