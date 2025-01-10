//
//  FilmResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 18/8/24.
//

import Foundation

/// `MoviesResponse` represents a general response containing a list of movies.
/// It includes pagination information and an array of detailed movie responses.
struct MoviesResponse: Codable {
  /// The current page number.
  let page: Int
  /// An array of detailed movie responses.
  let results: [MovieDetailSingleResponse]
}
