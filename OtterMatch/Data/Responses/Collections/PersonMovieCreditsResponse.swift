//
//  PersonMovieCreditsResponse.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import Foundation

/// `PersonMovieCreditsResponse` represents the cast and crew information for a movie.
/// It contains the movie ID, and optional arrays of cast and crew members.
final class PersonMovieCreditsResponse: Identifiable, Sendable {
  /// The unique identifier of the movie.
  let id: Int
  /// An optional array of cast members.
  let cast: [PersonMovieCreditsAsCastMember]?
  /// An optional array of crew members.
  let crew: [PersonMovieCreditsAsCrewMember]?
  
  /// Initializes a new `PersonMovieCreditsResponse` instance.
  /// - Parameters:
  ///   - id: The unique identifier of the movie.
  ///   - cast: An optional array of `MovieCreditsCastMember`.
  ///   - crew: An optional array of `MovieCreditsCrewMember`.
  init(id: Int, cast: [PersonMovieCreditsAsCastMember]?, crew: [PersonMovieCreditsAsCrewMember]?) {
    self.id = id
    self.cast = cast
    self.crew = crew
  }
}

extension PersonMovieCreditsResponse: Codable {
  enum CodingKeys: String, CodingKey {
    case id, cast, crew
  }
}

extension PersonMovieCreditsResponse: CustomStringConvertible {
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
