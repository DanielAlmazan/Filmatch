//
//  SimpleFriendMatch.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import Foundation

struct SimpleFriendMatch: Identifiable {
  let user: OtterMatchUser
  let matches: [Match]

  var id: String { user.id }

  static let `default` = SimpleFriendMatch(user: .default, matches: [.movieMock])
}

extension SimpleFriendMatch: Equatable {
  static func == (lhs: SimpleFriendMatch, rhs: SimpleFriendMatch) -> Bool {
    lhs.user == rhs.user
  }
}
