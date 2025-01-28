//
//  MoviesRemoteDatasourceImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/12/24.
//

import Foundation

final class MoviesRemoteDatasourceImpl: MoviesRemoteDatasource {
  private let client: TMDBHttpClient

  /// Initializes a new `HttpClient` instance, setting up default query parameters like language and region.
  init(client: TMDBHttpClient) {
    self.client = client
  }

  /// Fetches detailed information about a movie by its ID.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: A `MovieDetailSingleResponse` object containing detailed movie information.
  func getMovie(byId id: Int) async -> Result<MovieDetailSingleResponse, Error>
  {
    let endpoint = "movie/\(id)"
    let extraItems = [
      URLQueryItem(
        name: QueryParam.appendToResponse.rawValue, value: "credits,videos")
    ]

    return await client.get(
      endpoint,
      extraQueryItems: extraItems,
      responseType: MovieDetailSingleResponse.self
    )
  }

  /// Fetches the credits (cast and crew) for a specific movie.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: A `MovieCredits` object containing cast and crew information.
  func getMovieCredits(id: Int) async -> Result<PersonMovieCreditsResponse, Error> {
    let endpoint = "movie/\(id)/credits"
    return await client.get(
      endpoint,
      extraQueryItems: [],
      responseType: PersonMovieCreditsResponse.self
    )
  }
  
  func getProviders(forMovieId id: Int) async -> Result<WatchProvidersResponse, any Error> {
    let endpoint = "movie/\(id)/watch/providers"
    return await client.get(
      endpoint,
      extraQueryItems: [],
      responseType: WatchProvidersResponse.self)
  }

  /// Discovers movies based on the provided query parameters.
  /// - Parameter queryParams: An array of `URLQueryItem` representing query parameters for the discover endpoint.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: An array of `DiscoverMoviesItem` containing discovered movies.
  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async
    -> Result<[DiscoverMoviesItemSingleResponse], Error>
  {
    let endpoint = "discover/movie"
    return await client.get(
      endpoint,
      extraQueryItems: queryParams,
      responseType: DiscoverMoviesResponse.self
    ).map { $0.results }
  }

  /// Searches for movies based on a query string and other optional parameters. (Currently returns an empty array as it's not implemented.)
  /// - Parameters:
  ///   - query: The search query string.
  ///   - page: The page number for pagination.
  /// - Throws: An error if the operation fails.
  /// - Returns: An array of `MoviesSearchResponse`.
  func searchMovies(_ query: String, page: Int?) async -> Result<MoviesSearchResponse, Error> {
    let endpoint = "search/movie"
    return await client.get(
      endpoint,
      extraQueryItems: [
        URLQueryItem(name: QueryParam.page.rawValue, value: "\(page ?? 1)"),
        URLQueryItem(name: QueryParam.query.rawValue, value: query)
      ],
      responseType: MoviesSearchResponse.self)
  }

  /// Retrieves videos (like trailers and teasers) associated with a specific movie.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: A `MovieVideosResponse` object containing video information.
  func getVideos(byMovieId id: Int) async -> Result<MovieVideosResponse, Error>
  {
    let endpoint = "movie/\(id)/videos"
    return await client.get(
      endpoint,
      extraQueryItems: [],
      responseType: MovieVideosResponse.self
    )
  }
}
