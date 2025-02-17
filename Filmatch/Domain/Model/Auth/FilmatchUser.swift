//
//  FilmatchUser.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/1/25.
//

import Foundation
import FirebaseAuth

final class FilmatchUser: Identifiable, Sendable {
  let id: Int
  let email: String
  let username: String?
  let uid: String
  
  init(id: Int, email: String, username: String?, uid: String) {
    self.id = id
    self.email = email
    self.username = username
    self.uid = uid
  }
  
  static let `default` = FilmatchUser(id: 0, email: "user@example.com", username: "gas_esnake", uid: "Firebase UID")
}

extension FilmatchUser: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case email
    case username
    case uid
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let id = try container.decode(Int.self, forKey: .id)
    let email = try container.decode(String.self, forKey: .email)
    let username = try container.decodeIfPresent(String.self, forKey: .username)
    let uid = try container.decode(String.self, forKey: .uid)
    
    self.init(id: id,
              email: email,
              username: username,
              uid: uid)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(id, forKey: .id)
    try container.encode(email, forKey: .email)
    try container.encodeIfPresent(username, forKey: .username)
    try container.encode(uid, forKey: .uid)
  }
}

extension FilmatchUser: Equatable {
  static func == (lhs: FilmatchUser, rhs: FilmatchUser) -> Bool {
    return lhs.id == rhs.id
    && lhs.email == rhs.email
    && lhs.username == rhs.username
    && lhs.uid == rhs.uid
  }
}
