//
//  TvSeriesDetailViewModel.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/1/25.
//

import Foundation

@Observable
final class TvSeriesDetailViewModel {
  var tvSeries: DetailTvSeries?
  var providers: WatchProvidersResponse?
  
  var isTvSeriesLoading: Bool = false
  
  var errorMessage: String?
  
  private let repository: TvSeriesRepository
  
  init(repository: TvSeriesRepository) {
    self.repository = repository
  }
  
  @MainActor
  func loadTvSeries(byId id: Int) {
    self.errorMessage = nil
    self.isTvSeriesLoading = true
    
    Task {
      let result = await self.repository.getTvSeries(byId: id)
      
      switch result {
      case .success(let tvSeries):
        self.tvSeries = tvSeries.toDetailTvSeries()
      case .failure(let error):
        self.errorMessage = error.localizedDescription
        print(error)
      }
    }
    self.isTvSeriesLoading = false
  }
  
  @MainActor
  func loadProviders(forTvSeriesId id: Int) {
    self.errorMessage = nil
    
    Task {
      let result = await self.repository.getProviders(forTvSeriesId: id)
      
      switch result {
      case .success(let providers):
        self.providers = providers
      case .failure(let error):
        self.errorMessage = error.localizedDescription
        print(error)
      }
    }
  }
}
