//
//  MovieVideosAppendResponse.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 8/9/24.
//

import Foundation

/// `MovieVideosAppendResponse` represents an embedded response for movie videos when using the `append_to_response` parameter in the API.
/// It contains an optional array of `Video` objects.
final class MovieVideosAppendResponse: Codable, Sendable {
  /// An optional array of video results associated with the movie.
  let results: [Video]?

  /// Initializes a new `MovieVideosAppendResponse`.
  /// - Parameter results: An optional array of `Video` objects.
  init(results: [Video]?) {
    self.results = results
  }

  // MARK: - Codable Conformance

  enum CodingKeys: String, CodingKey {
    case results
  }

  /// Decodes the object from a decoder.
  /// - Parameter decoder: The decoder to read data from.
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let results = try container.decodeIfPresent([Video].self, forKey: .results)
    self.init(results: results)
  }

  /// Encodes the object into an encoder.
  /// - Parameter encoder: The encoder to write data to.
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(results, forKey: .results)
  }
}
