//
//  TvSeriesDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 4/1/25.
//

import Foundation

@MainActor
protocol TvSeriesDatasource {
  /// Returns tv series by ID if it exists.
  func getTvSeries(byId id: Int) async -> Result<TvSeriesDetailSingleResponse, Error>
  
  /// Returns a [TvShowDetailResponse] based on the providers passed.
  func discoverTvSeries(withQueryParams queryParams: [URLQueryItem]) async
  -> Result<DiscoverTvSeriesResponse, Error>
  
  /// Returns a `Result<[ProviderModel], Error>` with the providers of a specific Tv Series
  func getProviders(forTvSeriesId id: Int) async -> Result<WatchProvidersResponse, Error>
  
  /// Returns a [MovieDetailResponse] based on the providers passed.
  func searchTvSeries(_ query: String, page: Int?) async -> Result<DiscoverTvSeriesResponse, Error>
}
