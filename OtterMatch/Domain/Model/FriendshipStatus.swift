//
//  FriendshipStatus.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/2/25.
//

import Foundation

enum FriendshipStatus: Int, Sendable, Codable {
  case notRelated
  case sent
  case received
  case friend
  case blocked
}
