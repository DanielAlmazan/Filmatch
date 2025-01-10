//
//  Client.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/12/24.
//

import Foundation

protocol Client {
  func get<T: Decodable>(
    _ endpoint: String,
    extraQueryItems: [URLQueryItem],
    responseType: T.Type,
    acceptanceRange: Range<Int>?
  ) async -> Result<T, Error>
}
