//
//  DiscoverItem.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/1/25.
//

import Foundation

protocol DiscoverItem: Identifiable {
  var mediaType: MediaType { get }
  var backdropPath: String? { get }
  var genreIds: [Int] { get }
  var id: Int { get }
  var originalLanguage: String? { get }
  var overview: String? { get }
  var popularity: Double { get }
  var posterPath: String? { get }
  var voteAverage: Double { get }
  var voteCount: Int { get }
  
  var getTitle: String { get }
  var getReleaseDate: String { get }
}
