//
//  TvSeriesDatasourceImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class TvSeriesDatasourceImpl: TvSeriesDatasource {
  private let client: HttpClient

  init(client: HttpClient) {
    self.client = client
  }

  func getTvSeries(byId id: Int) async -> Result<
    TvSeriesDetailSingleResponse, any Error
  > {
    await client.get(
      "/tv/\(id)",
      extraQueryItems: [
        URLQueryItem(
          name: QueryParam.appendToResponse.rawValue, value: "aggregate_credits"
        )
      ],
      responseType: TvSeriesDetailSingleResponse.self)
  }

  func discoverTvSeries(withQueryParams queryParams: [URLQueryItem]) async
    -> Result<[DiscoverTvSeriesItemSingleResponse], any Error>
  {
    await client
      .get(
        "/discover/tv",
        extraQueryItems: queryParams,
        responseType: DiscoverTvSeriesResponse.self
      )
      .map { $0.results }
  }

  func searchTvSeries(
    _ query: String, includeAdult: Bool?, primaryReleaseDate: String?,
    page: Int?, region: String?, year: Int?
  ) async -> Result<[MoviesSearchResponse], any Error> {
    .failure(RuntimeErrors.notImplemented)
  }
}
