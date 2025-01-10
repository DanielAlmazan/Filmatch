//
//  PersonDetailResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

final class PersonDetailResponse: Codable {
  let adult: Bool
  let alsoKnownAs: [String]
  let biography: String
  let birthday: String
  let deathday: String?
  let gender: Gender
  let homepage: String?
  let id: Int
  let imdbId: String
  let knownForDepartment: String
  let name: String
  let placeOfBirth: String
  let popularity: Double
  let profilePath: String

  init(
    adult: Bool, alsoKnownAs: [String], biography: String, birthday: String,
    deathday: String?, gender: Gender, homepage: String?, id: Int,
    imdbId: String, knownForDepartment: String, name: String,
    placeOfBirth: String, popularity: Double, profilePath: String
  ) {
    self.adult = adult
    self.alsoKnownAs = alsoKnownAs
    self.biography = biography
    self.birthday = birthday
    self.deathday = deathday
    self.gender = gender
    self.homepage = homepage
    self.id = id
    self.imdbId = imdbId
    self.knownForDepartment = knownForDepartment
    self.name = name
    self.placeOfBirth = placeOfBirth
    self.popularity = popularity
    self.profilePath = profilePath
  }

}

extension PersonDetailResponse {
  enum CodingKeys: String, CodingKey {
    case adult, biography, birthday, deathday, gender, homepage, id, name,
      popularity
    case alsoKnownAs = "also_known_as"
    case imdbId = "imdb_id"
    case knownForDepartment = "known_for_department"
    case placeOfBirth = "place_of_birth"
    case profilePath = "profile_path"
  }

  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let adult = try container.decode(Bool.self, forKey: .adult)
    let alsoKnownAs = try container.decode([String].self, forKey: .alsoKnownAs)
    let biography = try container.decode(String.self, forKey: .biography)
    let birthday = try container.decode(String.self, forKey: .birthday)
    let deathday = try container.decode(String?.self, forKey: .deathday)

    let genderId = try container.decode(Int.self, forKey: .gender)
    let gender = Gender(rawValue: genderId) ?? .notSet

    let homepage = try container.decode(String?.self, forKey: .homepage)
    let id = try container.decode(Int.self, forKey: .id)
    let imdbId = try container.decode(String.self, forKey: .imdbId)
    let knownForDepartment = try container.decode(
      String.self, forKey: .knownForDepartment)
    let name = try container.decode(String.self, forKey: .name)
    let placeOfBirth = try container.decode(String.self, forKey: .placeOfBirth)
    let popularity = try container.decode(Double.self, forKey: .popularity)
    let profilePath = try container.decode(String.self, forKey: .profilePath)

    self.init(
      adult: adult, alsoKnownAs: alsoKnownAs, biography: biography,
      birthday: birthday, deathday: deathday, gender: gender,
      homepage: homepage, id: id, imdbId: imdbId,
      knownForDepartment: knownForDepartment, name: name,
      placeOfBirth: placeOfBirth, popularity: popularity,
      profilePath: profilePath)
  }
}

extension PersonDetailResponse {
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(adult, forKey: .adult)
    try container.encode(alsoKnownAs, forKey: .alsoKnownAs)
    try container.encode(biography, forKey: .biography)
    try container.encode(birthday, forKey: .birthday)
    try container.encode(deathday, forKey: .deathday)
    try container.encode(gender, forKey: .gender)
    try container.encode(homepage, forKey: .homepage)
    try container.encode(id, forKey: .id)
    try container.encode(imdbId, forKey: .imdbId)
    try container.encode(knownForDepartment, forKey: .knownForDepartment)
    try container.encode(name, forKey: .name)
    try container.encode(placeOfBirth, forKey: .placeOfBirth)
    try container.encode(popularity, forKey: .popularity)
    try container.encode(profilePath, forKey: .profilePath)
  }
}

extension PersonDetailResponse: CustomStringConvertible {
  var description: String {
    """
    Person:
     - Id: \(id)
     - Name: \(name)
     - ProfilePath: \(profilePath)
    """
  }
}
