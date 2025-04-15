//
//  MovieVideosResponse.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import Foundation

/// `MovieVideosResponse` represents the response from an API call fetching videos related to a movie.
/// It contains the movie ID and an array of `Video` objects.
final class MovieVideosResponse: Identifiable, Sendable, Codable {
  /// The unique identifier of the movie.
  let id: Int
  /// An array of video results associated with the movie.
  let results: [Video]
  
  /// Initializes a new `MovieVideosResponse`.
  /// - Parameters:
  ///   - id: The unique identifier of the movie.
  ///   - results: An array of `Video` objects.
  init(id: Int, results: [Video]) {
    self.id = id
    self.results = results
  }
  
  // MARK: - Codable Conformance
  
  enum CodingKeys: String, CodingKey {
    case id, results
  }
  
  /// Decodes the object from a decoder.
  /// - Parameter decoder: The decoder to read data from.
  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let id = try container.decode(Int.self, forKey: .id)
    let results = try container.decode([Video].self, forKey: .results)
    self.init(id: id, results: results)
  }
  
  /// Encodes the object into an encoder.
  /// - Parameter encoder: The encoder to write data to.
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(results, forKey: .results)
  }
}
