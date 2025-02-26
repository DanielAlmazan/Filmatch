//
//  JsonFiltersDatasource.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/12/24.
//

import Foundation

final class JsonFiltersDatasource: FiltersDatasource {
  let client = TMDBJsonClient()
  
  func getGenres(for mediaType: MediaType) async -> Result<[Genre], any Error> {
    return await client.get(
      "genres-\(mediaType.rawValue)-list",
      extraQueryItems: [],
      responseType: GenresResult.self,
      acceptanceRange: nil
    )
    .map { $0.genres }
  }
  
  func getProviders(for mediaType: MediaType) async -> Result<[FiltersStreamingProviderSingleResponse], any Error> {
    return await client.get(
      "watch-providers-\(mediaType.rawValue)",
      extraQueryItems: [],
      responseType: FiltersProvidersResponse.self,
      acceptanceRange: nil
    )
    .map { $0.results }
  }
}
