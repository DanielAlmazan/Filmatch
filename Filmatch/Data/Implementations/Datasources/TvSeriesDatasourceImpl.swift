//
//  TvSeriesDatasourceImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class TvSeriesDatasourceImpl: TvSeriesDatasource {
  private let client: TMDBHttpClient

  init(client: TMDBHttpClient) {
    self.client = client
  }

  func getTvSeries(byId id: Int) async -> Result<
    TvSeriesDetailSingleResponse, any Error
  > {
    await client.get(
      "tv/\(id)",
      extraQueryItems: [
        URLQueryItem(
          name: QueryParam.appendToResponse.rawValue, value: "aggregate_credits"
        )
      ],
      responseType: TvSeriesDetailSingleResponse.self)
  }
  
  func getProviders(forTvSeriesId id: Int) async -> Result<WatchProvidersResponse, any Error> {
    await client.get(
      "tv/\(id)/watch/providers",
      extraQueryItems: [],
      responseType: WatchProvidersResponse.self
    )
  }

  func discoverTvSeries(withQueryParams queryParams: [URLQueryItem]) async
    -> Result<[DiscoverTvSeriesItemSingleResponse], any Error>
  {
    await client
      .get(
        "discover/tv",
        extraQueryItems: queryParams,
        responseType: DiscoverTvSeriesResponse.self
      )
      .map { $0.results }
  }

  func searchTvSeries(_ query: String, page: Int?) async -> Result<DiscoverTvSeriesResponse, any Error> {
    await client.get(
      "search/tv",
      extraQueryItems: [
        URLQueryItem(name: QueryParam.query.rawValue, value: query),
        URLQueryItem(name: QueryParam.page.rawValue, value: "\(page ?? 1)")
      ],
      responseType: DiscoverTvSeriesResponse.self
    )
  }
}
