//
//  DetailTvSeriesMatchesResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/3/25.
//

import Foundation

final class DetailTvSeriesMatchesResponse: Sendable {
  let page: Int
  let totalResults: Int
  let totalPages: Int
  let resultsPerPage: Int
  let results: [TvSeriesMatchSingleResponse]
  let friend: OtterMatchUserResponse

  init(page: Int, totalResults: Int, totalPages: Int, resultsPerPage: Int, results: [TvSeriesMatchSingleResponse], friend: OtterMatchUserResponse) {
    self.page = page
    self.totalResults = totalResults
    self.totalPages = totalPages
    self.resultsPerPage = resultsPerPage
    self.results = results
    self.friend = friend
  }
}

extension DetailTvSeriesMatchesResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case page
    case totalResults = "total_results"
    case totalPages = "total_pages"
    case resultsPerPage = "results_per_page"
    case results
    case friend
  }

  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let page = try container.decode(Int.self, forKey: .page)
    let totalResults = try container.decode(Int.self, forKey: .totalResults)
    let totalPages = try container.decode(Int.self, forKey: .totalPages)
    let resultsPerPage = try container.decode(Int.self, forKey: .resultsPerPage)
    let results = try container.decode([TvSeriesMatchSingleResponse].self, forKey: .results)
    let friend = try container.decode(OtterMatchUserResponse.self, forKey: .friend)
    
    self.init(
      page: page,
      totalResults: totalResults,
      totalPages: totalPages,
      resultsPerPage: resultsPerPage,
      results: results,
      friend: friend)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(page, forKey: .page)
    try container.encode(totalResults, forKey: .totalResults)
    try container.encode(totalPages, forKey: .totalPages)
    try container.encode(resultsPerPage, forKey: .resultsPerPage)
    try container.encode(results, forKey: .results)
    try container.encode(friend, forKey: .friend)
  }
}
