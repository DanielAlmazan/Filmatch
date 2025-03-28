//
//  FilmatchGoQueryParam.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 1/3/25.
//

import Foundation

enum FilmatchGoQueryParam {
  case page(Int)
  case ids(String)
  case filtersHash(String)
  case interestStatus(InterestStatus)
  case query(String)
  case friendshipStatuses([FriendshipStatus])
  case sortByStatusFirst(FriendshipStatus)
  case resultsPerPage(Int)

  var value: URLQueryItem {
    switch self {
    case .page(let page):
      return .init(name: "page", value: "\(page)")
    case .ids(let ids):
      return .init(name: "ids", value: ids)
    case .filtersHash(let hash):
      return .init(name: "filters_hash", value: hash)
    case .interestStatus(let status):
      return .init(name: "status", value: "\(status.rawValue)")
    case .query(let query):
      return .init(name: "query", value: query)
    case .friendshipStatuses(let statuses):
      let strStatuses: String = statuses.map { "\($0.rawValue)" }.joined(separator: ",")
      return .init(name: "friendship_statuses", value: strStatuses)
    case .sortByStatusFirst(let status):
      return .init(name: "sort_by_status_first", value: "\(status.rawValue)")
    case .resultsPerPage(let count):
      return .init(name: "results_per_page", value: "\(count)")
    }
  }
}
