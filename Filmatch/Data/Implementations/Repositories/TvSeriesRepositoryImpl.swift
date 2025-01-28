//
//  TvSeriesRepositoryImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/1/25.
//

import Foundation

@Observable
final class TvSeriesRepositoryImpl: TvSeriesRepository {
  private let remoteDatasource: TvSeriesDatasource
  
  init(datasource: TvSeriesDatasource) {
    self.remoteDatasource = datasource
  }
  
  func getTvSeries(byId id: Int) async -> Result<TvSeriesDetailSingleResponse, any Error> {
    await remoteDatasource.getTvSeries(byId: id)
  }
  
  func getProviders(forTvSeriesId id: Int) async -> Result<WatchProvidersResponse, any Error> {
    await remoteDatasource.getProviders(forTvSeriesId: id)
  }
  
  func discoverTvSeries(withQueryParams queryParams: [URLQueryItem]) async -> Result<[DiscoverTvSeriesItemSingleResponse], any Error> {
    await remoteDatasource.discoverTvSeries(withQueryParams: queryParams)
  }
  
  func searchTvSeries(_ query: String, page: Int?) async -> Result<DiscoverTvSeriesResponse, Error> {
    await remoteDatasource.searchTvSeries(query, page: page)
  }
}
