//
//  FiltersRepository.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/12/24.
//

import Foundation

@MainActor
protocol FiltersRepository {
  func getGenres(for mediaType: MediaType) async -> Result<[Genre], Error>
  func getProviders(for mediaType: MediaType) async -> Result<[FiltersStreamingProviderSingleResponse], Error>
}
