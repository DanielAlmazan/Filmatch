//
//  FiltersRepositoryImpl.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 22/12/24.
//

import Foundation
import Observation

@Observable final class FiltersRepositoryImpl: FiltersRepository {
  let filtersDatasource: FiltersDatasource
  
  init(filtersDatasource: FiltersDatasource) {
    self.filtersDatasource = filtersDatasource
  }

  func getGenres(for mediaType: MediaType) async -> Result<[Genre], Error> {
    await filtersDatasource.getGenres(for: mediaType)
  }
  
  func getProviders(for mediaType: MediaType) async -> Result<[FiltersStreamingProviderSingleResponse], Error> {
    await filtersDatasource.getProviders(for: mediaType)
  }
}
