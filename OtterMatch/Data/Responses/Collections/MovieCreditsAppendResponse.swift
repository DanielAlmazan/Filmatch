//
//  MovieCreditsAppendResponse.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/9/24.
//

import Foundation

/// `MovieCreditsAppendResponse` represents an embedded response for
/// movie credits when using the `append_to_response` parameter in the API.
/// It contains optional arrays of cast and crew members.
final class MovieCreditsAppendResponse: Codable, Sendable {
  /// An optional array of cast members.
  let cast: [CastMember]?
  /// An optional array of crew members.
  let crew: [MovieCrewMember]?
  
  /// Initializes a new `MovieCreditsAppendResponse`.
  /// - Parameters:
  ///   - cast: An optional array of `CastMember`.
  ///   - crew: An optional array of `CrewMember`.
  init(cast: [CastMember]?, crew: [MovieCrewMember]?) {
    self.cast = cast
    self.crew = crew
  }
  
  // MARK: - Codable Conformance
  
  enum CodingKeys: String, CodingKey {
    case cast, crew
  }
  
  /// Decodes the object from a decoder.
  /// - Parameter decoder: The decoder to read data from.
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let cast = try container.decodeIfPresent([CastMember].self, forKey: .cast)
    let crew = try container.decodeIfPresent([MovieCrewMember].self, forKey: .crew)
    self.init(cast: cast, crew: crew)
  }
  
  /// Encodes the object into an encoder.
  /// - Parameter encoder: The encoder to write data to.
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encodeIfPresent(cast, forKey: .cast)
    try container.encodeIfPresent(crew, forKey: .crew)
  }
}
