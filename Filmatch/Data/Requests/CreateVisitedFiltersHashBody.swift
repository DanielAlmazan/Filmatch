//
//  CreateVisitedFiltersHashBody.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 13/2/25.
//

import Foundation

final class CreateVisitedFiltersHashBody: Encodable {
  let filtersHash: String
  let page: Int
  
  init(filtersHash: String, page: Int) {
    self.filtersHash = filtersHash
    self.page = page
  }
  
  private enum CodingKeys: String, CodingKey {
    case filtersHash = "filters_hash"
    case page = "max_page"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(self.filtersHash, forKey: .filtersHash)
    try container.encode(self.page, forKey: .page)
  }
}
