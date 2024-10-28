//
//  JsonPresetRepository.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/9/24.
//

import Foundation

/// An enumeration of errors that can occur within the `JsonPresetRepository`.
enum JsonPresetRepositoryError: String, Error {
  case notImplemented = "Function not implemented yet"
  case fileNotFound = "File not found"
  case decodingError = "Decoding error"
}

/// `JsonPresetRepository` is a class that implements the `MoviesRepository` protocol.
/// It provides movie data by loading preset JSON files included in the app bundle.
/// This is typically used for testing or development purposes where network calls are not desired.
class JsonPresetRepository: MoviesRepository {
  /// Loads a JSON file from the app bundle and decodes it into a specified type.
  /// - Parameters:
  ///   - filename: The name of the JSON file (without the extension).
  ///   - type: The type to decode the JSON data into.
  /// - Throws: An error if the file is not found or decoding fails.
  /// - Returns: An instance of the specified type containing the decoded data.
  func loadJson<T: Decodable>(filename: String, type: T.Type) throws -> T {
    guard
      let url = Bundle.main.url(forResource: filename, withExtension: "json")
    else {
      print("Error loading file \"\(filename)\"")
      throw JsonPresetRepositoryError.fileNotFound
    }

    let data = try Data(contentsOf: url)
    let decoder = JSONDecoder()

    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      throw error
    }
  }

  /// Retrieves movie details by ID from a preset JSON file.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error if the file is not found or decoding fails.
  /// - Returns: An optional `MovieDetailSingleResponse` containing the movie details.
  func getMovie(byId id: Int) async throws -> MovieDetailSingleResponse? {
    try loadJson(
      filename: "movie-\(id)-append_to_response-videos_credits",
      type: MovieDetailSingleResponse.self)
  }

  /// Retrieves a list of movie providers.
  /// - Throws: An error if the function is not implemented.
  /// - Returns: An array of `MovieProvider`.
  func getProviders() async throws -> [MovieProvider] {
    throw JsonPresetRepositoryError.notImplemented
  }

  /// Retrieves movie credits by movie ID.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error indicating that the function is not implemented.
  /// - Returns: A `MovieCredits` object containing the credits.
  func getMovieCredits(id: Int) async throws -> MovieCredits {
    throw JsonPresetRepositoryError.notImplemented
  }

  /// Discovers movies based on query parameters by loading preset JSON files.
  /// - Parameter queryParams: An array of `URLQueryItem` containing query parameters.
  /// - Throws: An error if the file is not found or decoding fails.
  /// - Returns: An array of `DiscoverMoviesItem` containing discovered movies.
  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async throws
    -> [DiscoverMoviesItem]
  {
    var page = 1

    // Extract the page number from the query parameters if available.
    if let pageParam = queryParams.first(where: { $0.name == "page" })?.value,
      let pageNumber = Int(pageParam)
    {
      page = pageNumber
    }

    let filename = "discover_movies-page\(page)"

    return try loadJson(filename: filename, type: DiscoverMoviesResponse.self)
      .results
  }

  
  /// Searches for movies based on a query string and other optional parameters.
  /// - Parameters:
  ///   - query: The search query string.
  ///   - includeAdult: Whether to include adult content in the results.
  ///   - primaryReleaseDate: The primary release date to filter results.
  ///   - page: The page number of results to retrieve.
  ///   - region: The region code to filter results.
  ///   - year: The year to filter results.
  /// - Throws: An error if the function is not implemented.
  /// - Returns: An array of `MoviesSearchResponse`.
  func searchMovies(
    _ query: String, includeAdult: Bool?, primaryReleaseDate: String?,
    page: Int?, region: String?, year: Int?
  ) async throws -> [MoviesSearchResponse] {
    throw JsonPresetRepositoryError.notImplemented
  }

  /// Retrieves videos associated with a movie by its ID.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error indicating that the function is not implemented.
  /// - Returns: A `MovieVideosResponse` containing video information.
  func getVideos(byMovieId id: Int) async throws -> MovieVideosResponse {
    throw JsonPresetRepositoryError.notImplemented
  }
  
  func getPerson(byId id: Int) async throws -> PersonDetailSingleResponse? {
    try loadJson(
      filename: "person-\(id)-append_to_response-movie_credits",
      type: PersonDetailSingleResponse.self)
  }
}
