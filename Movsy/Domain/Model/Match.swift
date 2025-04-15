//
//  Match.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import Foundation

struct Match: Identifiable {
  let isSuperMatch: Bool
  let item: any DiscoverItem
  var status: InterestStatus
  
  var id: Int { item.id }
  
  static let movieMock = Match(isSuperMatch: true, item: DiscoverMovieItem.default, status: .superInterested)
}

extension Match: Equatable {
  static func == (lhs: Match, rhs: Match) -> Bool {
    lhs.id == rhs.id
  }
}
