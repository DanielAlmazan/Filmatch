//
//  TvSeriesMatchesGroupedByFriendsResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 14/3/25.
//

import Foundation

final class TvSeriesMatchesGroupedByFriendsResponse: Sendable {
  let page: Int
  let results: [FriendTvSeriesMatchesSingleResponse]
  let resultsPerPage: Int
  let totalPages: Int
  let totalResults: Int
  
  init(page: Int, results: [FriendTvSeriesMatchesSingleResponse], resultsPerPage: Int, totalPages: Int, totalResults: Int) {
    self.page = page
    self.results = results
    self.resultsPerPage = resultsPerPage
    self.totalPages = totalPages
    self.totalResults = totalResults
  }
}

extension TvSeriesMatchesGroupedByFriendsResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case page
    case results
    case resultsPerPage = "results_per_page"
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let page = try container.decode(Int.self, forKey: .page)
    let results = try container.decode([FriendTvSeriesMatchesSingleResponse].self, forKey: .results)
    let resultsPerPage = try container.decode(Int.self, forKey: .resultsPerPage)
    let totalPages = try container.decode(Int.self, forKey: .totalPages)
    let totalResults = try container.decode(Int.self, forKey: .totalResults)
    
    self.init(
      page: page,
      results: results,
      resultsPerPage: resultsPerPage,
      totalPages: totalPages,
      totalResults: totalResults)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(page, forKey: .page)
    try container.encode(results, forKey: .results)
    try container.encode(resultsPerPage, forKey: .resultsPerPage)
    try container.encode(totalPages, forKey: .totalPages)
    try container.encode(totalResults, forKey: .totalResults)
  }
}
