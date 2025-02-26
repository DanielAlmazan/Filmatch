//
//  DiscoverMoviesResponse.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

/// `DiscoverMoviesResponse` represents the response from the movie discovery API call.
/// It contains pagination information and an array of discovered movies.
final class DiscoverMoviesResponse: Sendable, Codable {
  /// The current page number.
  let page: Int
  /// An array of discovered movies.
  let results: [DiscoverMoviesItemSingleResponse]
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
