//
//  MoviesRemoteDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/12/24.
//

import Foundation

protocol MoviesRemoteDatasource {
  /// Returns movie by ID if it exists.
  func getMovie(byId id: Int) async -> Result<MovieDetailSingleResponse, Error>
  
  /// Gets credits from a movie
  func getMovieCredits(id: Int) async -> Result<MovieCredits, Error>
  
  /// Returns a [MovieDetailResponse] based on the providers passed.
  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async
  -> Result<[DiscoverMoviesItemSingleResponse], Error>
  
  /// Returns a [MovieDetailResponse] based on the providers passed.
  func searchMovies(
    _ query: String, includeAdult: Bool?, primaryReleaseDate: String?,
    page: Int?, region: String?, year: Int?
  ) async -> Result<[MoviesSearchResponse], Error>
  
  /// Gets the videos of an specific movie
  func getVideos(byMovieId id: Int) async -> Result<MovieVideosResponse, Error>
}
