//
//  TvSeriesDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 4/1/25.
//

import Foundation

protocol TvSeriesDatasource {
  /// Returns tv show by ID if it exists.
  func getTvSeries(byId id: Int) async -> Result<TvSeriesDetailSingleResponse, Error>
  
  /// Returns a [TvShowDetailResponse] based on the providers passed.
  func discoverTvSeries(withQueryParams queryParams: [URLQueryItem]) async
  -> Result<[DiscoverTvSeriesItemSingleResponse], Error>
  
  /// Returns a [MovieDetailResponse] based on the providers passed.
//  func searchTvSeries(
//    _ query: String, includeAdult: Bool?, primaryReleaseDate: String?,
//    page: Int?, region: String?, year: Int?
//  ) async -> Result<[MoviesSearchResponse], Error>
}
