//
//  MovsyClient.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 26/1/25.
//

import Foundation

protocol MovsyClient: Sendable {
  func request(
    path: MovsyGoPaths,
    method: HTTPMethods,
    queryParams: [MovsyGoQueryParam]?,
    body: Data?,
    acceptedStatusCodes: [Int]
  ) async -> Result<Data, Error>
}

extension MovsyClient {
  func request(
    path: MovsyGoPaths,
    method: HTTPMethods,
    queryParams: [MovsyGoQueryParam]? = nil,
    body: Data? = nil,
    acceptedStatusCodes: [Int] = Array(200...299)
  ) async -> Result<Data, Error> {
    await self.request(
      path: path,
      method: method,
      queryParams: queryParams,
      body: body,
      acceptedStatusCodes: acceptedStatusCodes
    )
  }
}
