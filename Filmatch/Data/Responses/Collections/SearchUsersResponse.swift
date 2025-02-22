//
//  SearchUsersResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import Foundation

final class SearchUsersResponse: Sendable {
  let page: Int
  let results: [FilmatchUser]
  let resultsPerPage: Int
  let totalPages: Int
  let totalResults: Int
  
  init(page: Int, results: [FilmatchUser], resultsPerPage: Int, totalPages: Int, totalResults: Int) {
    self.page = page
    self.results = results
    self.resultsPerPage = resultsPerPage
    self.totalPages = totalPages
    self.totalResults = totalResults
  }
}

extension SearchUsersResponse: Decodable {
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
    let results = try container.decode([FilmatchUser].self, forKey: .results)
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
}
