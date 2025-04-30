//
//  MovsyUser.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 24/2/25.
//

import Foundation

struct MovsyUser: Identifiable {
  let email: String?
  var username: String?
  let uid: String
  let photoUrl: String?
  var isEmailVerified: Bool?
  var friendshipStatus: FriendshipStatus?

  var isVerified: Bool { isEmailVerified ?? false }
  var isNotVerified: Bool { !isVerified }
  var maskedEmail: String? {
    guard let email else { return nil }
    let parts = email.split(separator: "@")
    return "\(parts.first!.prefix(2))...@\(parts.last!)"
  }

  var id: String { uid }

  init(
    email: String?,
    username: String?,
    uid: String,
    photoUrl: String?,
    friendshipStatus: FriendshipStatus?,
    isEmailVerified: Bool?,
  ) {
    self.email = email
    self.username = username
    self.uid = uid
    self.photoUrl = photoUrl
    self.friendshipStatus = friendshipStatus
    self.isEmailVerified = isEmailVerified
  }
  
  static let `default` = MovsyUser(
    email: "user@example.com",
    username: "gas_esnake",
    uid: "Firebase UID",
    photoUrl: "https://upload.wikimedia.org/wikipedia/commons/d/d9/Robin_Wright_Cannes_2017_%28cropped%29.jpg",
    friendshipStatus: nil,
    isEmailVerified: true,
  )
}

extension MovsyUser: Equatable {
  static func == (lhs: MovsyUser, rhs: MovsyUser) -> Bool {
    return lhs.id == rhs.id
    && lhs.email == rhs.email
    && lhs.username == rhs.username
    && lhs.uid == rhs.uid
    && lhs.photoUrl == rhs.photoUrl
    && lhs.friendshipStatus == rhs.friendshipStatus
    && lhs.isEmailVerified == rhs.isEmailVerified
  }
}

extension [MovsyUser]? {
  mutating func setUsers(_ users: [MovsyUser]) {
    self == nil ? self = users : self!.append(contentsOf: users)
  }
}
