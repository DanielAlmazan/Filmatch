//
//  DiscoverTvSeriesResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 4/1/25.
//

import Foundation

final class DiscoverTvSeriesResponse: Decodable {
  /// The current page number.
  let page: Int
  /// An array of discovered tv shows.
  let results: [DiscoverTvSeriesItemSingleResponse]
  /// The total number of pages available.
  let totalPages: Int
  /// The total number of results found.
  let totalResults: Int
  
  enum CodingKeys: String, CodingKey {
    case page
    case results
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
}
