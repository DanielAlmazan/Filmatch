//
//  CastMember.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 18/8/24.
//

import Foundation

/// `CastMember` represents an actor or actress who is part of a movie's cast.
final class MovieCastMember: Identifiable, Codable, Sendable {
  /// The unique identifier of the cast member.
  let id: Int
  /// Indicates whether the cast member is an adult.
  let adult: Bool
  /// The gender of the cast member.
  let gender: Gender
  /// The department the cast member is known for.
  let knownForDepartment: String
  /// The name of the cast member.
  let name: String
  /// The original name of the cast member.
  let originalName: String
  /// The popularity score of the cast member.
  let popularity: Double
  /// The path to the cast member's profile image.
  let profilePath: String?
  /// The cast ID.
  let castId: Int
  /// The character played by the cast member.
  let character: String
  /// The credit ID associated with the cast member.
  let creditId: String
  /// The order in which the cast member appears.
  let order: Int
  
  /// Initializes a new `CastMember` instance.
  /// - Parameters:
  ///   - id: The unique identifier of the cast member.
  ///   - adult: Indicates whether the cast member is an adult.
  ///   - gender: The gender of the cast member.
  ///   - knownForDepartment: The department the cast member is known for.
  ///   - name: The name of the cast member.
  ///   - originalName: The original name of the cast member.
  ///   - popularity: The popularity score of the cast member.
  ///   - profilePath: The path to the cast member's profile image.
  ///   - castId: The cast ID.
  ///   - character: The character played by the cast member.
  ///   - creditId: The credit ID associated with the cast member.
  ///   - order: The order in which the cast member appears.
  init(
    id: Int,
    adult: Bool,
    gender: Gender,
    knownForDepartment: String,
    name: String,
    originalName: String,
    popularity: Double,
    profilePath: String?,
    castId: Int,
    character: String,
    creditId: String,
    order: Int
  ) {
    self.id = id
    self.adult = adult
    self.gender = gender
    self.knownForDepartment = knownForDepartment
    self.name = name
    self.originalName = originalName
    self.popularity = popularity
    self.profilePath = profilePath
    self.castId = castId
    self.character = character
    self.creditId = creditId
    self.order = order
  }
  
  enum CodingKeys: String, CodingKey {
    case id, adult, gender, name, popularity, character, order
    case knownForDepartment = "known_for_department"
    case originalName = "original_name"
    case profilePath = "profile_path"
    case castId = "cast_id"
    case creditId = "credit_id"
  }
  
  /// A default instance of `CastMember` for testing purposes.
  static let `default` = MovieCastMember(
    id: 26723,
    adult: false,
    gender: .female,
    knownForDepartment: "Acting",
    name: "Katheryn Winnick",
    originalName: "Katheryn Winnick",
    popularity: 111.311,
    profilePath: "/vQSqH3ybDWZHZIqX4NZKhOCXAhQ.jpg",
    castId: 12,
    character: "Vivian",
    creditId: "5a95d69392514154ed006aa8",
    order: 2
  )
}

extension MovieCastMember: CustomStringConvertible {
  /// A textual description of the cast member.
  var description: String {
    return """
        CastMember:
            - id: \(id)
            - adult: \(adult)
            - gender: \(gender)
            - knownForDepartment: \(knownForDepartment)
            - name: \(name)
            - originalName: \(originalName)
            - popularity: \(popularity)
            - profilePath: \(profilePath ?? "No profile photo")
            - castId: \(castId)
            - character: \(character)
            - creditId: \(creditId)
            - order: \(order)
        """
  }
}
