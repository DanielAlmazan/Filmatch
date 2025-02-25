//
//  Creator.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class Creator: Identifiable, Sendable {
  let id: Int
  let creditId: String?
  let name: String?
  let originalName: String?
  let gender: Gender
  let profilePath: String?
  
  init(id: Int, creditId: String?, name: String?, originalName: String?, gender: Gender, profilePath: String?) {
    self.id = id
    self.creditId = creditId
    self.name = name
    self.originalName = originalName
    self.gender = gender
    self.profilePath = profilePath
  }
}

extension Creator: Codable {
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case creditId = "credit_id"
    case name = "name"
    case originalName = "original_name"
    case gender = "gender"
    case profilePath = "profile_path"
  }
  
  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let id = try container.decode(Int.self, forKey: .id)
    let creditId = try container.decodeIfPresent(String.self, forKey: .creditId)
    let name = try container.decodeIfPresent(String.self, forKey: .name)
    let originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
    let gender = try container.decode(Gender.self, forKey: .gender)
    let profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
    
    self.init(id: id,
              creditId: creditId,
              name: name,
              originalName: originalName,
              gender: gender,
              profilePath: profilePath)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(id, forKey: .id)
    try container.encode(creditId, forKey: .creditId)
    try container.encode(name, forKey: .name)
    try container.encode(originalName, forKey: .originalName)
    try container.encode(gender, forKey: .gender)
    try container.encode(profilePath, forKey: .profilePath)
  }
}

extension Creator: Equatable {
  static func == (lhs: Creator, rhs: Creator) -> Bool {
    lhs.id == rhs.id
  }
}

extension Creator: CustomStringConvertible {
  var description: String {
    "Creator: \(id) - \(name ?? "No name")"
  }
}
