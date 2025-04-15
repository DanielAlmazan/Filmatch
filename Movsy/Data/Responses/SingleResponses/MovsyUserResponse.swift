//
//  MovsyUserResponse.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 27/1/25.
//

//import FirebaseAuth
import Foundation

final class MovsyUserResponse: Identifiable, Sendable {
  let email: String?
  let username: String?
  let uid: String
  let photoUrl: String?
  let friendshipStatus: FriendshipStatus?

  init(email: String?, username: String?, uid: String, photoUrl: String?, friendshipStatus: FriendshipStatus?) {
    self.email = email
    self.username = username
    self.uid = uid
    self.photoUrl = photoUrl
    self.friendshipStatus = friendshipStatus
  }

  static let `default` = MovsyUserResponse(
    email: "user@example.com",
    username: "gas_esnake",
    uid: "Firebase UID",
    photoUrl: nil,
    friendshipStatus: nil
  )
}

extension MovsyUserResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case email
    case username
    case uid
    case photoUrl = "photo_url"
    case friendshipStatus = "friendship_status"
  }

  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let email = try container.decodeIfPresent(String.self, forKey: .email)
    let username = try container.decodeIfPresent(String.self, forKey: .username)
    let uid = try container.decode(String.self, forKey: .uid)
    let photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
    let friendshipStatus = try container.decodeIfPresent(FriendshipStatus.self, forKey: .friendshipStatus)

    self.init(
      email: email,
      username: username,
      uid: uid,
      photoUrl: photoUrl,
      friendshipStatus: friendshipStatus
    )
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encodeIfPresent(email, forKey: .email)
    try container.encodeIfPresent(username, forKey: .username)
    try container.encode(uid, forKey: .uid)
    try container.encode(photoUrl, forKey: .photoUrl)
    try container.encode(friendshipStatus, forKey: .friendshipStatus)
  }
}

extension MovsyUserResponse: Equatable {
  static func == (lhs: MovsyUserResponse, rhs: MovsyUserResponse) -> Bool {
    return lhs.id == rhs.id
      && lhs.email == rhs.email
      && lhs.username == rhs.username
      && lhs.uid == rhs.uid
      && lhs.photoUrl == rhs.photoUrl
      && lhs.friendshipStatus == rhs.friendshipStatus
  }
}
