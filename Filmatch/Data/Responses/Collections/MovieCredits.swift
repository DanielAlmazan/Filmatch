//
//  MovieCredits.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import Foundation

/// `MovieCredits` represents the cast and crew information for a movie.
/// It contains the movie ID, and optional arrays of cast and crew members.
final class MovieCredits: Identifiable, Codable {
  /// The unique identifier of the movie.
  let id: Int
  /// An optional array of cast members.
  let cast: [MovieCastMember]?
  /// An optional array of crew members.
  let crew: [MovieCrewMember]?
  
  /// Initializes a new `MovieCredits` instance.
  /// - Parameters:
  ///   - id: The unique identifier of the movie.
  ///   - cast: An optional array of `CastMember`.
  ///   - crew: An optional array of `CrewMember`.
  init(id: Int, cast: [MovieCastMember]?, crew: [MovieCrewMember]?) {
    self.id = id
    self.cast = cast
    self.crew = crew
  }
  
  enum CodingKeys: String, CodingKey {
    case id, cast, crew
  }
}

extension MovieCredits: CustomStringConvertible {
  /// A textual representation of the movie credits, including cast and crew information.
  var description: String {
    let castMembers = cast?.description ?? "No cast available"
    let crewMembers = crew?.description ?? "No crew available"
    return """
        MovieCredits:
        - id: \(id)
        - cast: \(castMembers)
        - crew: \(crewMembers)
        """
  }
}
