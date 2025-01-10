//
//  TvSeriesRepository.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 4/1/25.
//

import Foundation

protocol TvSeriesRepository {
  /// Returns tv show by ID if it exists.
  func getTvSeries(byId id: Int) async -> Result<TvSeriesDetailSingleResponse, Error>

  /// Returns a [DiscoverTvSeriesItemSingleResponse] based on the providers passed.
  func discoverTvSeries(withQueryParams queryParams: [URLQueryItem]) async
    -> Result<[DiscoverTvSeriesItemSingleResponse], Error>

  /// Returns a [MovieDetailResponse] based on the providers passed.
//  func searchTvShows(
//    _ query: String, includeAdult: Bool?, primaryReleaseDate: String?,
//    page: Int?, region: String?, year: Int?
//  ) async -> Result<[TvSeriesSearchResponse], Error>
}
