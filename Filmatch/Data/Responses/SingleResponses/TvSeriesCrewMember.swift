//
//  TvSeriesCrewMember.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class TvSeriesCrewMember: Identifiable, Sendable {
  let adult: Bool
  let gender: Gender
  let id: Int
  let knownForDepartment: String?
  let name: String
  let originalName: String?
  let popularity: Double
  let profilePath: String?
  let jobs: [TvSeriesCrewJob]
  let department: String?
  let totalEpisodeCount: Int?
  
  init(adult: Bool,
       gender: Gender,
       id: Int,
       knownForDepartment: String?,
       name: String,
       originalName: String?,
       popularity: Double,
       profilePath: String?,
       jobs: [TvSeriesCrewJob],
       department: String?,
       totalEpisodeCount: Int?
  ) {
    self.adult = adult
    self.gender = gender
    self.id = id
    self.knownForDepartment = knownForDepartment
    self.name = name
    self.originalName = originalName
    self.popularity = popularity
    self.profilePath = profilePath
    self.jobs = jobs
    self.department = department
    self.totalEpisodeCount = totalEpisodeCount
  }
}

extension TvSeriesCrewMember: Codable {
  enum CodingKeys: String, CodingKey {
    case adult, gender, id
    case knownForDepartment = "known_for_department"
    case name
    case originalName = "original_name"
    case popularity
    case profilePath = "profile_path"
    case jobs, department
    case totalEpisodeCount = "total_episode_count"
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let adult = try container.decode(Bool.self, forKey: .adult)
    let gender = try container.decode(Gender.self, forKey: .gender)
    let id = try container.decode(Int.self, forKey: .id)
    let knownForDepartment = try container.decode(String?.self, forKey: .knownForDepartment)
    let name = try container.decode(String.self, forKey: .name)
    let originalName = try container.decode(String?.self, forKey: .originalName)
    let popularity = try container.decode(Double.self, forKey: .popularity)
    let profilePath = try container.decode(String?.self, forKey: .profilePath)
    let jobs = try container.decode([TvSeriesCrewJob].self, forKey: .jobs)
    let department = try container.decode(String?.self, forKey: .department)
    let totalEpisodeCount = try container.decode(Int?.self, forKey: .totalEpisodeCount)
    
    self.init(adult: adult,
              gender: gender,
              id: id,
              knownForDepartment: knownForDepartment,
              name: name,
              originalName: originalName,
              popularity: popularity,
              profilePath: profilePath,
              jobs: jobs,
              department: department,
              totalEpisodeCount: totalEpisodeCount)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(adult, forKey: .adult)
    try container.encode(gender, forKey: .gender)
    try container.encode(id, forKey: .id)
    try container.encode(knownForDepartment, forKey: .knownForDepartment)
    try container.encode(name, forKey: .name)
    try container.encode(originalName, forKey: .originalName)
    try container.encode(popularity, forKey: .popularity)
    try container.encode(profilePath, forKey: .profilePath)
    try container.encode(jobs, forKey: .jobs)
    try container.encode(department, forKey: .department)
    try container.encode(totalEpisodeCount, forKey: .totalEpisodeCount)
  }
}

extension TvSeriesCrewMember: Equatable {
  static func == (lhs: TvSeriesCrewMember, rhs: TvSeriesCrewMember) -> Bool {
    lhs.id == rhs.id
  }
}


/*
 adult
 gender
 id
 known_for_department
 name
 original_name
 popularity
 profile_path
 jobs
 department
 total_episode_count
 */
