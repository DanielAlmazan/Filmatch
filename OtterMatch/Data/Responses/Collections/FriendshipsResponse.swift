//
//  FriendshipsResponse.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import Foundation

final class FriendshipsResponse: Sendable, Codable {
  let page: Int
  let results: [FriendshipSingleResponse]
  let resultsPerPage: Int
  let totalPages: Int
  let totalResults: Int
  
  private enum CodingKeys: String, CodingKey {
    case page
    case results = "results"
    case resultsPerPage = "results_per_page"
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.page = try container.decode(Int.self, forKey: .page)
    self.results = try container.decode([FriendshipSingleResponse].self, forKey: .results)
    self.resultsPerPage = try container.decode(Int.self, forKey: .resultsPerPage)
    self.totalPages = try container.decode(Int.self, forKey: .totalPages)
    self.totalResults = try container.decode(Int.self, forKey: .totalResults)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(self.page, forKey: .page)
    try container.encode(self.results, forKey: .results)
    try container.encode(self.resultsPerPage, forKey: .resultsPerPage)
    try container.encode(self.totalPages, forKey: .totalPages)
    try container.encode(self.totalResults, forKey: .totalResults)
  }
}
