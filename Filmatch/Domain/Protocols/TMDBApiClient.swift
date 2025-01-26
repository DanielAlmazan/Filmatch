//
//  DataApiClient.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/12/24.
//

import Foundation

protocol TMDBApiClient {
  func get<T: Decodable>(
    _ endpoint: String,
    extraQueryItems: [URLQueryItem],
    responseType: T.Type,
    acceptanceRange: Range<Int>?
  ) async -> Result<T, Error>
}
