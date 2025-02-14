//
//  LatestPageByVisitedFiltersHashData.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 13/2/25.
//

import Foundation

final class LatestPageByVisitedFiltersHashData: Sendable, Decodable {
  let userId: Int
  let latestPage: Int
  let filtersHash: String
  
  init(userId: Int, latestPage: Int, filtersHash: String) {
    self.userId = userId
    self.latestPage = latestPage
    self.filtersHash = filtersHash
  }
  
  private enum CodingKeys: String, CodingKey {
    case userId = "user_id"
    case latestPage = "max_page"
    case filtersHash = "filters_hash"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
   
    self.userId = try container.decode(Int.self, forKey: .userId)
    self.latestPage = try container.decode(Int.self, forKey: .latestPage)
    self.filtersHash = try container.decode(String.self, forKey: .filtersHash)
  }
}
