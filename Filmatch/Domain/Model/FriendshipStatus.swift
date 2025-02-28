//
//  FriendshipStatus.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/2/25.
//

import Foundation

enum FriendshipStatus: Int, Sendable, Codable {
  case notRelated = 0
  case sent = 1
  case received = 2
  case friend = 3
  case blocked = 4
}
