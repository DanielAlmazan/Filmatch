//
//  JsonTvSeriesDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/1/25.
//

import Foundation

final class JsonTvSeriesDatasource: TvSeriesDatasource {
  let client = JsonClient()

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

  func discoverTvSeries(withQueryParams queryParams: [URLQueryItem]) async
    -> Result<[DiscoverTvSeriesItemSingleResponse], any Error>
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
    .map { $0.results }
  }
}
