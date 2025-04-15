//
//  MovieMatchesByFriendUidResponse.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 14/3/25.
//

import Foundation

final class MovieMatchesByFriendUidResponse: Identifiable {
  let friendUid: String
  let page: Int
  let results: [MovieMatchSingleResponse]
  let resultsPerPage: Int
  let totalPages: Int
  let totalResults: Int
  
  var id: String { friendUid }
  
  init(friendUid: String, page: Int, results: [MovieMatchSingleResponse], resultsPerPage: Int, totalPages: Int, totalResults: Int) {
    self.friendUid = friendUid
    self.page = page
    self.results = results
    self.resultsPerPage = resultsPerPage
    self.totalPages = totalPages
    self.totalResults = totalResults
  }
}

extension MovieMatchesByFriendUidResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case friendUid = "friend_uid"
    case page
    case results
    case resultsPerPage = "results_per_page"
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let friendUid = try container.decode(String.self, forKey: .friendUid)
    let page = try container.decode(Int.self, forKey: .page)
    let results = try container.decode([MovieMatchSingleResponse].self, forKey: .results)
    let resultsPerPage = try container.decode(Int.self, forKey: .resultsPerPage)
    let totalPages = try container.decode(Int.self, forKey: .totalPages)
    let totalResults = try container.decode(Int.self, forKey: .totalResults)
    
    self.init(
      friendUid: friendUid,
      page: page,
      results: results,
      resultsPerPage: resultsPerPage,
      totalPages: totalPages,
      totalResults: totalResults)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(friendUid, forKey: .friendUid)
    try container.encode(page, forKey: .page)
    try container.encode(results, forKey: .results)
    try container.encode(resultsPerPage, forKey: .resultsPerPage)
    try container.encode(totalPages, forKey: .totalPages)
    try container.encode(totalResults, forKey: .totalResults)
  }
}
