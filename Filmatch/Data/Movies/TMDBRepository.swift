//
//  TMDBRepository.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 16/8/24.
//

import Foundation

/// `TMDBRepository` is a concrete implementation of the `MoviesRepository` protocol.
/// It communicates with The Movie Database (TMDb) API to fetch movie-related data such as movie details, credits, and videos.
/// This class handles constructing requests, adding necessary query parameters, and decoding the JSON responses into model objects.
final class TMDBRepository: MoviesRepository {
  /// The base URL for TMDb API requests.
  internal var urlBase: String = "https://api.themoviedb.org/3"
  
  /// The API key required for TMDb API authentication.
  private let apiKey: String = Config.shared.apiKey
  
  /// The access token for authentication (if needed).
  private let accessTokenAuth: String = Config.shared.accessTokenAuth
  
  /// An array of common query items added to every request.
  private var queryItems: [URLQueryItem]
  
  /// Initializes a new `TMDBRepository` instance, setting up default query parameters like language and region.
  init() {
    let language = "\(Locale.preferredLanguages.first ?? "en-US")"
    let watchRegion = "\(Locale.current.region ?? "US")"

    queryItems = [
      URLQueryItem(name: "language", value: "\(language)"),
      URLQueryItem(name: "api_key", value: "\(apiKey)"),
      URLQueryItem(name: "watch_region", value: watchRegion),
    ]
  }

  /// Fetches detailed information about a movie by its ID.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: A `MovieDetailSingleResponse` object containing detailed movie information.
  func getMovie(byId id: Int) async throws -> MovieDetailSingleResponse? {
    let url = URL(string: "\(urlBase)/movie/\(id)")!
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!

    // Append additional query parameters specific to this request.
    queryItems.append(contentsOf: [
      URLQueryItem(name: "append_to_response", value: "videos,credits")
    ])

    components.queryItems =
      components.queryItems.map { $0 + queryItems } ?? queryItems

    var request = URLRequest(url: components.url!)
    request.httpMethod = HTTPMethods.GET.rawValue
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
      "accept": "application/json"
    ]

    // Perform the network request.
    let (data, _) = try await URLSession.shared.data(for: request)
    
//    print(String(decoding: data, as: UTF8.self))

    // Decode the JSON response into the model object.
    let decoder = JSONDecoder()
    return try decoder.decode(MovieDetailSingleResponse.self, from: data)
  }

  /// Retrieves a list of movie providers. (Currently returns an empty array as it's not implemented.)
  /// - Throws: An error if the operation fails.
  /// - Returns: An array of `MovieProvider`.
  func getProviders() async throws -> [MovieProvider] {
    []
  }

  /// Fetches the credits (cast and crew) for a specific movie.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: A `MovieCredits` object containing cast and crew information.
  func getMovieCredits(id: Int) async throws -> MovieCredits {
    let url = URL(string: "\(urlBase)/movie/\(id)/credits")!

    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!

    components.queryItems =
      components.queryItems.map { $0 + queryItems } ?? queryItems

    var request = URLRequest(url: components.url!)
    request.httpMethod = HTTPMethods.GET.rawValue
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
      "accept": "application/json"
    ]

    let (data, _) = try await URLSession.shared.data(for: request)

    let decoder = JSONDecoder()
    return try decoder.decode(MovieCredits.self, from: data)
  }

  /// Discovers movies based on the provided query parameters.
  /// - Parameter queryParams: An array of `URLQueryItem` representing query parameters for the discover endpoint.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: An array of `DiscoverMoviesItem` containing discovered movies.
  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async throws
    -> [DiscoverMoviesItem]
  {
    let url = URL(string: "\(urlBase)/discover/movie")!

    queryParams.forEach { item in
      self.queryItems.append(item)
    }

    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!

    components.queryItems =
      components.queryItems.map { $0 + queryItems } ?? queryItems

    var request = URLRequest(url: components.url!)
    request.httpMethod = HTTPMethods.GET.rawValue
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
      "accept": "application/json"
    ]

    let (data, _) = try await URLSession.shared.data(for: request)

    let decoder = JSONDecoder()
    return try decoder.decode(DiscoverMoviesResponse.self, from: data).results
  }

  /// Searches for movies based on a query string and other optional parameters. (Currently returns an empty array as it's not implemented.)
  /// - Parameters:
  ///   - query: The search query string.
  ///   - includeAdult: Whether to include adult content.
  ///   - primaryReleaseDate: The primary release date to filter results.
  ///   - page: The page number for pagination.
  ///   - region: The region code to filter results.
  ///   - year: The year to filter results.
  /// - Throws: An error if the operation fails.
  /// - Returns: An array of `MoviesSearchResponse`.
  func searchMovies(
    _ query: String, includeAdult: Bool?, primaryReleaseDate: String?,
    page: Int?, region: String?, year: Int?
  ) async throws -> [MoviesSearchResponse] {
    []
  }

  /// Retrieves videos (like trailers and teasers) associated with a specific movie.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: A `MovieVideosResponse` object containing video information.
  func getVideos(byMovieId id: Int) async throws -> MovieVideosResponse {
    let url = URL(string: "\(urlBase)/movie/\(id)/videos")!

    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!

    components.queryItems =
      components.queryItems.map { $0 + queryItems } ?? queryItems

    var request = URLRequest(url: components.url!)
    request.httpMethod = HTTPMethods.GET.rawValue
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
      "accept": "application/json"
    ]

    let (data, _) = try await URLSession.shared.data(for: request)

    let decoder = JSONDecoder()
    return try decoder.decode(MovieVideosResponse.self, from: data)
  }
  
  func getPerson(byId id: Int) async throws -> PersonDetailSingleResponse? {
    let url = URL(string: "\(urlBase)/person/\(id)")!
    var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    
    components.queryItems = (components.queryItems ?? []) + queryItems
    
    var request = URLRequest(url: components.url!)
    request.httpMethod = HTTPMethods.GET.rawValue
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
      "accept": "application/json"
    ]
    
    let (data, _) = try await URLSession.shared.data(for: request)
    
    let decoder = JSONDecoder()
    return try decoder.decode(PersonDetailSingleResponse.self, from: data)
  }
}
