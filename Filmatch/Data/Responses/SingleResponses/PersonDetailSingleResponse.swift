//
//  PersonDetailSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/9/24.
//

import Foundation

/// `PersonDetailSingleResponse` represents detailed information about a person (actor, director, etc.) fetched from the API.
final class PersonDetailSingleResponse: Identifiable, Sendable {
  /// Specifies if does content for adults
  let adult: Bool
  /// An array of alternative names the person is known by.
  let alsoKnownAs: [String]
  /// The person's biography.
  let biography: String
  /// The person's birthday.
  let birthday: Date?
  /// The person's death day
  let deathday: Date?
  /// The person's gender.
  let gender: Gender
  /// The person's homepage if exists
  let homepage: String?
  /// The unique identifier of the person.
  let id: Int
  /// The IMDB person's ID
  let imdbId: String?
  /// The department the person is known for.
  let knownForDepartment: String
  /// The person's name.
  let name: String
  /// The place where the person was born.
  let placeOfBirth: String?
  /// The popularity score of the person.
  let popularity: Double
  /// The path to the person's profile image.
  let profilePath: String?
  /// The person's movie credits
  let movieCredits: PersonMovieCredits
  /// The person's tv credits
  let tvCredits: PersonTvCredits

  init(
    adult: Bool,
    alsoKnownAs: [String],
    biography: String,
    birthday: Date?,
    deathday: Date?,
    gender: Gender,
    homepage: String?,
    id: Int,
    imdbId: String?,
    knownForDepartment: String,
    name: String,
    placeOfBirth: String?,
    popularity: Double,
    profilePath: String?,
    movieCredits: PersonMovieCredits,
    tvCredits: PersonTvCredits
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
    self.movieCredits = movieCredits
    self.tvCredits = tvCredits
  }
}

extension PersonDetailSingleResponse: Codable {
  enum CodingKeys: String, CodingKey {
    case adult
    case alsoKnownAs = "also_known_as"
    case biography
    case birthday
    case deathday
    case gender
    case homepage
    case id
    case imdbId = "imdb_id"
    case knownForDepartment = "known_for_department"
    case name
    case placeOfBirth = "place_of_birth"
    case popularity
    case profilePath = "profile_path"
    case movieCredits = "movie_credits"
    case tvCredits = "tv_credits"
  }

  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let adult = try container.decode(Bool.self, forKey: .adult)
    let alsoKnownAs = try container.decode([String].self, forKey: .alsoKnownAs)
    let biography = try container.decode(String.self, forKey: .biography)
    
    let birthdayString = try container.decode(String?.self, forKey: .birthday)
    let birthday: Date? = {
      guard let dateStr = birthdayString, !dateStr.isEmpty else { return nil }
      return Utilities.dateFormatter.date(from: dateStr)
    }()
    
    let deathdayString = try container.decode(String?.self, forKey: .deathday)
    let deathday: Date? = {
      guard let dateStr = deathdayString, !dateStr.isEmpty else { return nil }
      return Utilities.dateFormatter.date(from: dateStr)
    }()
    
    let gender = try container.decode(Gender.self, forKey: .gender)
    let homepage = try container.decode(String?.self, forKey: .homepage)
    let id = try container.decode(Int.self, forKey: .id)
    let imdbID = try container.decode(String?.self, forKey: .imdbId)
    let knownForDepartment = try container.decode(String.self, forKey: .knownForDepartment)
    let name = try container.decode(String.self, forKey: .name)
    let placeOfBirth = try container.decode(String?.self, forKey: .placeOfBirth)
    let popularity = try container.decode(Double.self, forKey: .popularity)
    let profilePath = try container.decode(String?.self, forKey: .profilePath)
    let movieCredits = try container.decode(PersonMovieCredits.self, forKey: .movieCredits)
    let tvCredits = try container.decode(PersonTvCredits.self, forKey: .tvCredits)
    
    self.init(adult: adult,
              alsoKnownAs: alsoKnownAs,
              biography: biography,
              birthday: birthday,
              deathday: deathday,
              gender: gender,
              homepage: homepage,
              id: id,
              imdbId: imdbID,
              knownForDepartment: knownForDepartment,
              name: name,
              placeOfBirth: placeOfBirth,
              popularity: popularity,
              profilePath: profilePath,
              movieCredits: movieCredits,
              tvCredits: tvCredits)
  }
}
