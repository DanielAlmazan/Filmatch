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
  let client = JsonClient()

  func getMovie(byId id: Int) async -> Result<MovieDetailSingleResponse, Error>
  {
    await client.get(
      "movie-\(id)-append_to_response-videos_credits",
      extraQueryItems: [],
      responseType: MovieDetailSingleResponse.self,
      acceptanceRange: nil
    )
  }

  func getMovieCredits(id: Int) async -> Result<MovieCredits, Error> {
    .failure(JsonDatasourceError.notImplemented)
  }

  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async
    -> Result<[DiscoverMoviesItemSingleResponse], Error>
  {
    var page = 1
    if let pageParam = queryParams.first(where: { $0.name == "page" })?.value,
      let pageNumber = Int(pageParam)
    {
      page = pageNumber
    }

    return await client.get(
      "discover_movies-page\(page)",
      extraQueryItems: [],
      responseType: DiscoverMoviesResponse.self,
      acceptanceRange: nil
    )
    .map { $0.results }
  }

  func searchMovies(
    _ query: String, includeAdult: Bool?, primaryReleaseDate: String?,
    page: Int?, region: String?, year: Int?
  ) async -> Result<[MoviesSearchResponse], Error> {
    .failure(JsonDatasourceError.notImplemented)
  }

  func getVideos(byMovieId id: Int) async -> Result<MovieVideosResponse, Error>
  {
    .failure(JsonDatasourceError.notImplemented)
  }
}
