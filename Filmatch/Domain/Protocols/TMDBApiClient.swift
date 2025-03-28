//
//  DataApiClient.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/12/24.
//

import Foundation

@MainActor
protocol TMDBApiClient {
  func get<T: Decodable>(
    _ endpoint: String,
    extraQueryItems: [URLQueryItem],
    responseType: T.Type,
    acceptanceRange: Range<Int>?
  ) async -> Result<T, Error>
}

extension TMDBApiClient {
  func get<T>(
    _ endpoint: String,
    extraQueryItems: [URLQueryItem] = [],
    responseType: T.Type,
    acceptanceRange: Range<Int>? = nil
  ) async -> Result<T, any Error> where T: Decodable {
    await get(
      endpoint,
      extraQueryItems: extraQueryItems,
      responseType: responseType,
      acceptanceRange: acceptanceRange
    )
  }
}
