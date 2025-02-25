//
//  JsonMoviesRemoteDatasource.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/12/24.
//

import Foundation

enum JsonDatasourceError: String, Error {
  case fileNotFound = "File not found"
  case notImplemented = "Not implemented"
}

final class JsonMoviesRemoteDatasource: MoviesRemoteDatasource {
  let client = TMDBJsonClient()

  func getMovie(byId id: Int) async -> Result<MovieDetailSingleResponse, Error>
  {
    await client.get(
      "movie-\(id)-append_to_response-videos_credits",
      extraQueryItems: [],
      responseType: MovieDetailSingleResponse.self,
      acceptanceRange: nil
    )
  }

  func getMovieCredits(id: Int) async -> Result<
    PersonMovieCreditsResponse, Error
  > {
    .failure(JsonDatasourceError.notImplemented)
  }

  func getProviders(forMovieId id: Int) async -> Result<
    WatchProvidersResponse, any Error
  > {
    .failure(JsonDatasourceError.notImplemented)
  }

  func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async
    -> Result<DiscoverMoviesResponse, Error>
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
  }

  func searchMovies(_ query: String, page: Int?) async -> Result<
    MoviesSearchResponse, Error
  > {
    .failure(JsonDatasourceError.notImplemented)
  }

  func getVideos(byMovieId id: Int) async -> Result<MovieVideosResponse, Error>
  {
    .failure(JsonDatasourceError.notImplemented)
  }
}
