//
//  PersonDetailSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/9/24.
//

import Foundation

/// `PersonDetailSingleResponse` represents detailed information about a person (actor, director, etc.) fetched from the API.
final class PersonDetailSingleResponse: Codable, Sendable {
  /// The unique identifier of the person.
  let id: Int
  /// The person's name.
  let name: String
  /// The path to the person's profile image.
  let profilePath: String?
  /// The person's biography.
  let biography: String
  /// The department the person is known for.
  let knownForDepartment: String
  /// The person's birthday.
  let birthday: String?
  /// The place where the person was born.
  let placeOfBirth: String?
  /// An array of alternative names the person is known by.
  let alsoKnownAs: [String]
  /// The popularity score of the person.
  let popularity: Double
  /// The person's gender.
  let gender: Gender
  
  enum CodingKeys: String, CodingKey {
    case id, name, biography, birthday, gender, popularity
    case profilePath = "profile_path"
    case knownForDepartment = "known_for_department"
    case placeOfBirth = "place_of_birth"
    case alsoKnownAs = "also_known_as"
  }
}
