//
//  OtterMatchClient.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/1/25.
//

import Foundation

protocol OtterMatchClient: Sendable {
  func request(
    path: OtterMatchGoPaths,
    method: HTTPMethods,
    queryParams: [URLQueryItem]?,
    body: Data?,
    acceptedStatusCodes: [Int]
  ) async -> Result<Data, Error>
}

extension OtterMatchClient {
  func request(
    path: OtterMatchGoPaths,
    method: HTTPMethods,
    queryParams: [URLQueryItem]? = nil,
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
