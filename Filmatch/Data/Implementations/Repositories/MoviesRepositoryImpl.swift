//
//  MoviesRepositoryImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 16/8/24.
//

import Foundation

/// `MoviesRepositoryImpl` is a concrete implementation of the `MoviesRepository` protocol.
/// It communicates with The Movie Database (TMDb) API to fetch movie-related data such as movie details, credits, and videos.
/// This class handles constructing requests, adding necessary query parameters, and decoding the JSON responses into model objects.
@Observable
final class MoviesRepositoryImpl: MoviesRepository {
  private let remoteDatasource: MoviesRemoteDatasource

  init(datasource: MoviesRemoteDatasource) {
    self.remoteDatasource = datasource
  }

  func getMovie(byId id: Int) async -> Result<
    MovieDetailSingleResponse, any Error
  > {
    await remoteDatasource.getMovie(byId: id)
  }

  func getMovieCredits(id: Int) async -> Result<PersonMovieCreditsResponse, any Error> {
    await remoteDatasource.getMovieCredits(id: id)
  }
  
  func getProviders(forMovieId id: Int) async -> Result<WatchProvidersResponse, any Error> {
    await remoteDatasource.getProviders(forMovieId: id)
  }

  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async
    -> Result<[DiscoverMoviesItemSingleResponse], any Error>
  {
    await remoteDatasource.discoverMovies(withQueryParams: queryParams)
  }

  func searchMovies(_ query: String, page: Int?) async -> Result<MoviesSearchResponse, any Error> {
    await remoteDatasource.searchMovies(query, page: page)
  }

  func getVideos(byMovieId id: Int) async -> Result<
    MovieVideosResponse, any Error
  > {
    await remoteDatasource.getVideos(byMovieId: id)
  }
}
