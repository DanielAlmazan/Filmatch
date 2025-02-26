//
//  TvSeriesCastMember.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class TvSeriesCastMember: Identifiable, Sendable {
  let adult: Bool
  let gender: Int
  let id: Int
  let knownForDepartment: String?
  let name: String
  let originalName: String?
  let popularity: Double
  let profilePath: String?
  let roles: [TvSeriesCastRole]
  let totalEpisodeCount: Int?
  let order: Int
  
  init(adult: Bool,
       gender: Int,
       id: Int,
       knownForDepartment: String?,
       name: String,
       originalName: String?,
       popularity: Double,
       profilePath: String?,
       roles: [TvSeriesCastRole],
       totalEpisodeCount: Int?,
       order: Int
  ) {
    self.adult = adult
    self.gender = gender
    self.id = id
    self.knownForDepartment = knownForDepartment
    self.name = name
    self.originalName = originalName
    self.popularity = popularity
    self.profilePath = profilePath
    self.roles = roles
    self.totalEpisodeCount = totalEpisodeCount
    self.order = order
  }
}

extension TvSeriesCastMember: Codable {
  enum CodingKeys: String, CodingKey {
    case adult
    case gender
    case id
    case knownForDepartment = "known_for_department"
    case name
    case originalName = "original_name"
    case popularity
    case profilePath = "profile_path"
    case roles
    case totalEpisodeCount = "total_episode_count"
    case order
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let adult = try container.decode(Bool.self, forKey: .adult)
    let gender = try container.decode(Int.self, forKey: .gender)
    let id = try container.decode(Int.self, forKey: .id)
    let knownForDepartment = try container.decode(String?.self, forKey: .knownForDepartment)
    let name = try container.decode(String.self, forKey: .name)
    let originalName = try container.decode(String?.self, forKey: .originalName)
    let popularity = try container.decode(Double.self, forKey: .popularity)
    let profilePath = try container.decode(String?.self, forKey: .profilePath)
    let roles = try container.decode([TvSeriesCastRole].self, forKey: .roles)
    let totalEpisodeCount = try container.decode(Int?.self, forKey: .totalEpisodeCount)
    let order = try container.decode(Int.self, forKey: .order)
    
    self.init(adult: adult,
              gender: gender,
              id: id,
              knownForDepartment: knownForDepartment,
              name: name,
              originalName: originalName,
              popularity: popularity,
              profilePath: profilePath,
              roles: roles,
              totalEpisodeCount: totalEpisodeCount,
              order: order)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(adult, forKey: .adult)
    try container.encode(gender, forKey: .gender)
    try container.encode(id, forKey: .id)
    try container.encode(knownForDepartment, forKey: .knownForDepartment)
    try container.encode(name, forKey: .name)
    try container.encode(originalName, forKey: .originalName)
    try container.encode(popularity, forKey: .popularity)
    try container.encode(profilePath, forKey: .profilePath)
    try container.encode(roles, forKey: .roles)
    try container.encode(totalEpisodeCount, forKey: .totalEpisodeCount)
    try container.encode(order, forKey: .order)
  }
}

extension TvSeriesCastMember: Equatable {
  static func == (lhs: TvSeriesCastMember, rhs: TvSeriesCastMember) -> Bool {
    lhs.id == rhs.id
  }
}
