//
//  CrewMember.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import Foundation

/// `CrewMember` represents a member of the movie's crew, such as directors, writers, or producers.
final class MovieCrewMember: Identifiable, Codable, Sendable {
  /// The unique identifier of the crew member.
  let id: Int
  /// Indicates whether the crew member is an adult.
  let adult: Bool
  /// The gender of the crew member.
  let gender: Gender
  /// The department the crew member is known for.
  let knownForDepartment: String
  /// The name of the crew member.
  let name: String
  /// The original name of the crew member.
  let originalName: String
  /// The popularity score of the crew member.
  let popularity: Double
  /// The path to the crew member's profile image.
  let profilePath: String?
  /// The credit ID associated with the crew member.
  let creditId: String
  /// The department in which the crew member worked.
  let department: String
  /// The specific job or role of the crew member.
  let job: String
  
  /// Initializes a new `CrewMember` instance.
  /// - Parameters:
  ///   - id: The unique identifier of the crew member.
  ///   - adult: Indicates whether the crew member is an adult.
  ///   - gender: The gender of the crew member.
  ///   - knownForDepartment: The department the crew member is known for.
  ///   - name: The name of the crew member.
  ///   - originalName: The original name of the crew member.
  ///   - popularity: The popularity score of the crew member.
  ///   - profilePath: The path to the crew member's profile image.
  ///   - creditId: The credit ID associated with the crew member.
  ///   - department: The department in which the crew member worked.
  ///   - job: The specific job or role of the crew member.
  init(
    id: Int,
    adult: Bool,
    gender: Gender,
    knownForDepartment: String,
    name: String,
    originalName: String,
    popularity: Double,
    profilePath: String?,
    creditId: String,
    department: String,
    job: String
  ) {
    self.id = id
    self.adult = adult
    self.gender = gender
    self.knownForDepartment = knownForDepartment
    self.name = name
    self.originalName = originalName
    self.popularity = popularity
    self.profilePath = profilePath
    self.creditId = creditId
    self.department = department
    self.job = job
  }
  
  enum CodingKeys: String, CodingKey {
    case id, adult, gender, name, popularity, department, job
    case knownForDepartment = "known_for_department"
    case originalName = "original_name"
    case profilePath = "profile_path"
    case creditId = "credit_id"
  }
}

extension MovieCrewMember: CustomStringConvertible {
  /// A textual description of the crew member.
  var description: String {
        """
        CrewMember:
         - id: \(id)
         - adult: \(adult)
         - gender: \(gender)
         - knownForDepartment: \(knownForDepartment)
         - name: \(name)
         - originalName: \(originalName)
         - popularity: \(popularity)
         - profilePath: \(profilePath ?? "No profile photo")
         - creditId: \(creditId)
         - department: \(department)
         - job: \(job)
        """
  }
}
