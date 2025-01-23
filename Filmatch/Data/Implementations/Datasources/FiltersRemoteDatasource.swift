//
//  FiltersRemoteDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/12/24.
//

import Foundation

final class FiltersRemoteDatasource: FiltersDatasource {
  private let client: HttpClient

  init(client: HttpClient) {
    self.client = client
  }

  func getGenres(for mediaType: MediaType) async -> Result<[Genre], Error> {
    let response = await client.get(
      "genre/\(mediaType.rawValue)/list",
      extraQueryItems: [],
      responseType: GenresResult.self
    )
    return switch response {
    case .success(let genres):
      .success(genres.genres)
    case .failure(let error):
      .failure(error)
    }
  }

  func getProviders(for mediaType: MediaType) async -> Result<
    [FiltersStreamingProviderSingleResponse], Error
  > {
    let response = await client.get(
      "watch/providers/\(mediaType.rawValue)",
      extraQueryItems: [],
      responseType: FiltersProvidersResponse.self
    )
    return switch response {
    case .success(let providers):
      .success(providers.results)
    case .failure(let error):
      .failure(error)
    }
  }
}
