//
//  MoviesRemoteDatasourceImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/12/24.
//

import Foundation

final class MoviesRemoteDatasourceImpl: MoviesRemoteDatasource {
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
      URLQueryItem(name: "language", value: language),
      URLQueryItem(name: "api_key", value: apiKey),
      URLQueryItem(name: "watch_region", value: watchRegion),
    ]
  }
  
  /// Fetches detailed information about a movie by its ID.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: A `MovieDetailSingleResponse` object containing detailed movie information.
  func getMovie(byId id: Int) async -> Result<MovieDetailSingleResponse, Error> {
    let endpoint = "/movie/\(id)"
    let extraItems = [URLQueryItem(name: "append_to_response", value: "credits")]
    
    return await getRequest(
      endpoint: endpoint,
      extraQueryItems: extraItems,
      responseType: MovieDetailSingleResponse.self
    )
  }
  
  /// Retrieves a list of movie providers. (Currently returns an empty array as it's not implemented.)
  /// - Throws: An error if the operation fails.
  /// - Returns: An array of `MovieProvider`.
  func getProviders() async -> Result<[MovieProvider], Error> {
    return .success([])
  }
  
  /// Fetches the credits (cast and crew) for a specific movie.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: A `MovieCredits` object containing cast and crew information.
  func getMovieCredits(id: Int) async -> Result<MovieCredits, Error> {
    let endpoint = "/movie/\(id)/credits"
    return await getRequest(
      endpoint: endpoint,
      extraQueryItems: [],
      responseType: MovieCredits.self
    )
  }
  
  /// Discovers movies based on the provided query parameters.
  /// - Parameter queryParams: An array of `URLQueryItem` representing query parameters for the discover endpoint.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: An array of `DiscoverMoviesItem` containing discovered movies.
  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async
  -> Result<[DiscoverMoviesItem], Error> {
    let endpoint = "/discover/movie"
    return await getRequest(
      endpoint: endpoint,
      extraQueryItems: queryParams,
      responseType: DiscoverMoviesResponse.self
    ).map { $0.results }
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
  ) async -> Result<[MoviesSearchResponse], Error> {
    return .success([])
  }
  
  /// Retrieves videos (like trailers and teasers) associated with a specific movie.
  /// - Parameter id: The unique identifier of the movie.
  /// - Throws: An error if the network request fails or decoding fails.
  /// - Returns: A `MovieVideosResponse` object containing video information.
  func getVideos(byMovieId id: Int) async -> Result<MovieVideosResponse, Error> {
    let endpoint = "/movie/\(id)/videos"
    return await getRequest(
      endpoint: endpoint,
      extraQueryItems: [],
      responseType: MovieVideosResponse.self
    )
  }
  
  func getPerson(byId id: Int) async -> Result<PersonDetailSingleResponse, Error> {
    let endpoint = "/person/\(id)"
    return await getRequest(
      endpoint: endpoint,
      extraQueryItems: [],
      responseType: PersonDetailSingleResponse.self
    )
  }
}
 
extension MoviesRemoteDatasourceImpl {
  func getRequest<T: Decodable>(
    endpoint: String,
    extraQueryItems: [URLQueryItem],
    responseType: T.Type
  ) async -> Result<T, Error> {
    guard let url = URL(string: "\(urlBase)\(endpoint)") else {
      return .failure(URLError(.badURL))
    }
    
    guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
      return .failure(URLError(.badURL))
    }
    
    let allQueryItems = queryItems + extraQueryItems
    components.queryItems = components.queryItems.map { $0 + allQueryItems } ?? allQueryItems
    
    guard let componentsUrl = components.url else {
      return .failure(URLError(.badURL))
    }
    
    var request = URLRequest(url: componentsUrl)
    request.httpMethod = HTTPMethods.GET.rawValue
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
      "accept": "application/json"
    ]
    
    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      
      let decoder = JSONDecoder()
      let decoded = try decoder.decode(responseType.self, from: data)
      return .success(decoded)
    } catch {
      return .failure(error)
    }
  }
}
