//
//  TvSeriesDetailViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/1/25.
//

import Foundation

@Observable
final class TvSeriesDetailViewModel {
  var tvSeries: DetailTvSeries?
  
  var isTvSeriesLoading: Bool
  
  var errorMessage: String?
  
  private let repository: TvSeriesRepository
  
  init(repository: TvSeriesRepository) {
    self.repository = repository
    self.isTvSeriesLoading = true
  }
  
  @MainActor
  func loadTvSeries(byId id: Int) {
    self.errorMessage = nil
    
    Task {
      let result = await self.repository.getTvSeries(byId: id)
      
      switch result {
      case .success(let tvSeries):
        self.tvSeries = tvSeries.toDetailTvSeries()
      case .failure(let error):
        self.errorMessage = error.localizedDescription
        print(error)
      }
      self.isTvSeriesLoading = false
    }
  }
}
