//
//  InterestStatus.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 15/12/24.
//

import Foundation
import SwiftUICore

enum InterestStatus: Int, Codable, Identifiable, CaseIterable {
  case watchlist = 0
  case superHype = 1
  case blacklist = 2
  case watched = 3
  case pending = -1

  var id: Int { self.rawValue }

  var listName: LocalizedStringKey {
    switch self {
    case .watchlist:
      "Watchlist"
    case .superHype:
      "SuperHype"
    case .blacklist:
      "Blacklist"
    case .watched:
      "Watched"
    case .pending:
      "None"
    }
  }

  var icon: Image? {
    switch self {
    case .watchlist:
      Image(.watchlistIconFill)
    case .superHype:
      Image(.superHypedIconFill)
    case .blacklist:
      Image(.blacklistIconFill)
    case .watched:
      Image(.watchedIconFill)
    default:
      nil
    }
  }
}
