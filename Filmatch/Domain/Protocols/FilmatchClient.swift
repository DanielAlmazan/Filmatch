//
//  FilmatchClient.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/1/25.
//

import Foundation

protocol FilmatchClient: Sendable {
  func request(
    path: FilmatchGoPaths,
    method: HTTPMethods,
    queryParams: [String: String]?,
    body: Data?,
    acceptedStatusCodes: ClosedRange<Int>
  ) async -> Result<Data, Error>
  
  func request(
  path: FilmatchGoPaths,
  method: HTTPMethods
  ) async -> Result<Data, Error>
}
