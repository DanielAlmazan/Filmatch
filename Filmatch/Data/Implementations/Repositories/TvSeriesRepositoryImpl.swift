//
//  TvSeriesRepositoryImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/1/25.
//

import Foundation

@Observable final class TvSeriesRepositoryImpl: TvSeriesRepository {
  private let remoteDatasource: TvSeriesDatasource
  
  init(remoteDatasource: TvSeriesDatasource) {
    self.remoteDatasource = remoteDatasource
  }
  
  func getTvSeries(byId id: Int) async -> Result<TvSeriesDetailSingleResponse, any Error> {
    await remoteDatasource.getTvSeries(byId: id)
  }
  
  func discoverTvSeries(withQueryParams queryParams: [URLQueryItem]) async -> Result<[DiscoverTvSeriesItemSingleResponse], any Error> {
    await remoteDatasource.discoverTvSeries(withQueryParams: queryParams)
  }
}
