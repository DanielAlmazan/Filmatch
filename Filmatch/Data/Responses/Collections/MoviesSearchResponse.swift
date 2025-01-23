//
//  MoviesSearchResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import Foundation

/// `MoviesSearchResponse` represents the response from a movie search API call.
/// It contains pagination information and an array of search results.
final class MoviesSearchResponse: Codable, Sendable {
  /// The current page number.
  let page: Int
  /// An array of movie search results.
  let results: [DiscoverMoviesItemSingleResponse]
  /// The total number of pages available.
  let totalPages: Int
  /// The total number of results found.
  let totalResults: Int
  
  /// Initializes a new `MoviesSearchResponse`.
  /// - Parameters:
  ///   - page: The current page number.
  ///   - results: An array of `MovieSearchResultSingleResponse`.
  ///   - totalPages: The total number of pages available.
  ///   - totalResults: The total number of results found.
  init(page: Int, results: [DiscoverMoviesItemSingleResponse], totalPages: Int, totalResults: Int) {
    self.page = page
    self.results = results
    self.totalPages = totalPages
    self.totalResults = totalResults
  }
  
  enum CodingKeys: String, CodingKey {
    case page, results
    case totalPages = "total_pages"
    case totalResults = "total_results"
  }
}
