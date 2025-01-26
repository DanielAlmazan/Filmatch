//
//  JsonClient.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/12/24.
//

import Foundation

final class TMDBJsonClient: TMDBApiClient {
  func get<T>(
    _ endpoint: String,
    extraQueryItems: [URLQueryItem],
    responseType: T.Type,
    acceptanceRange: Range<Int>?
  ) async -> Result<T, any Error> where T: Decodable {
    guard let url = Bundle.main.url(forResource: endpoint, withExtension: "json") else {
      print("Error loading file \"\(endpoint).json\"")
      return .failure(JsonDatasourceError.fileNotFound)
    }
    
    do {
      let data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      let decoded = try decoder.decode(T.self, from: data)
      return .success(decoded)
    } catch {
      return .failure(error)
    }
  }
}
