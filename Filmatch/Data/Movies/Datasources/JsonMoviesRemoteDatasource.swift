//
//  JsonMoviesRemoteDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/12/24.
//

import Foundation

enum JsonDatasourceError: String, Error {
  case fileNotFound = "File not found"
  case notImplemented = "Not implemented"
}

final class JsonMoviesRemoteDatasource: MoviesRemoteDatasource {
  private func loadJson<T: Decodable>(filename: String, type: T.Type) -> Result<T, Error> {
    guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
      print("Error loading file \"\(filename).json\"")
      return .failure(JsonDatasourceError.fileNotFound)
    }
    
    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      let decoded = try decoder.decode(T.self, from: data)
      return .success(decoded)
    } catch {
      return .failure(error)
    }
  }
  
  func getMovie(byId id: Int) async -> Result<MovieDetailSingleResponse, Error> {
    loadJson(
      filename: "movie-\(id)-append_to_response-videos_credits",
      type: MovieDetailSingleResponse.self)
  }
  
  func getProviders() async -> Result<[MovieProvider], Error> {
    .failure(JsonDatasourceError.notImplemented)
  }
  
  func getMovieCredits(id: Int) async -> Result<MovieCredits, Error> {
    .failure(JsonDatasourceError.notImplemented)
  }
  
  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async -> Result<[DiscoverMoviesItem], Error> {
    var page = 1
    if let pageParam = queryParams.first(where: { $0.name == "page" })?.value,
       let pageNumber = Int(pageParam) {
      page = pageNumber
    }
    
    return loadJson(filename: "discover_movies-page\(page)", type: DiscoverMoviesResponse.self)
      .map { $0.results }

  }
  
  func searchMovies(_ query: String, includeAdult: Bool?, primaryReleaseDate: String?, page: Int?, region: String?, year: Int?) async -> Result<[MoviesSearchResponse], Error> {
    .failure(JsonDatasourceError.notImplemented)
  }
  
  func getVideos(byMovieId id: Int) async -> Result<MovieVideosResponse, Error> {
    .failure(JsonDatasourceError.notImplemented)
  }
  
  func getPerson(byId id: Int) async -> Result<PersonDetailSingleResponse, Error> {
    loadJson(filename: "person-\(id)-append_to_response-movie_credits", type: PersonDetailSingleResponse.self)
  }
}
