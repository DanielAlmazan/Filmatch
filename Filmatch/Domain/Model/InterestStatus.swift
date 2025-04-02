//
//  InterestStatus.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 15/12/24.
//

import Foundation
import SwiftUICore

enum InterestStatus: Int, Codable {
  case interested = 0
  case superInterested = 1
  case notInterested = 2
  case watched = 3
  case pending = -1

  var listName: LocalizedStringKey {
    switch self {
    case .interested:
      "Watchlist"
    case .superInterested:
      "SuperHype"
    case .notInterested:
      "Blacklist"
    case .watched:
      "Watched"
    case .pending:
      "None"
    }
  }

  var icon: Image? {
    switch self {
    case .interested:
      Image(.watchlistIconFill)
    case .superInterested:
      Image(.superHypedIconFill)
    case .notInterested:
      Image(.blacklistIconFill)
    case .watched:
      Image(.watchedIconFill)
    default:
      nil
    }
  }
}
