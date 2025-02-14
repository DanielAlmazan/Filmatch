//
//  JsonTvSeriesDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/1/25.
//

import Foundation

final class JsonTvSeriesDatasource: TvSeriesDatasource {
  let client = TMDBJsonClient()

  func getTvSeries(byId id: Int) async -> Result<
    TvSeriesDetailSingleResponse, any Error
  > {
    await client.get(
      "tv-\(id)-append_to_response-aggregate-credits",
      extraQueryItems: [],
      responseType: TvSeriesDetailSingleResponse.self,
      acceptanceRange: nil
    )
  }
  
  func getProviders(forTvSeriesId id: Int) async -> Result<WatchProvidersResponse, any Error> {
    .failure(JsonDatasourceError.notImplemented)
  }

  func discoverTvSeries(withQueryParams queryParams: [URLQueryItem]) async
    -> Result<DiscoverTvSeriesResponse, any Error>
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
      responseType: DiscoverTvSeriesResponse.self,
      acceptanceRange: nil
    )
  }
  
  func searchTvSeries(_ query: String, page: Int?) async -> Result<DiscoverTvSeriesResponse, Error> {
    .failure(JsonDatasourceError.notImplemented)
  }
}
