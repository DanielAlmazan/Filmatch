//
//  FilmatchUser.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/2/25.
//

import Foundation

struct FilmatchUser: Identifiable {
  let email: String?
  let username: String?
  let uid: String
  let photoUrl: String?
  var friendshipStatus: FriendshipStatus?

  var id: String { uid }

  init(email: String?, username: String?, uid: String, photoUrl: String?, friendshipStatus: FriendshipStatus?) {
    self.email = email
    self.username = username
    self.uid = uid
    self.photoUrl = photoUrl
    self.friendshipStatus = friendshipStatus
  }
  
  static let `default` = FilmatchUser(
    email: "user@example.com",
    username: "gas_esnake",
    uid: "Firebase UID",
    photoUrl: "https://upload.wikimedia.org/wikipedia/commons/d/d9/Robin_Wright_Cannes_2017_%28cropped%29.jpg",
    friendshipStatus: nil
  )
}

extension FilmatchUser: Equatable {
  static func == (lhs: FilmatchUser, rhs: FilmatchUser) -> Bool {
    return lhs.id == rhs.id
    && lhs.email == rhs.email
    && lhs.username == rhs.username
    && lhs.uid == rhs.uid
    && lhs.photoUrl == rhs.photoUrl
    && lhs.friendshipStatus == rhs.friendshipStatus
  }
}
