//
//  MovieCollectionSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

/// `MovieCollectionSingleResponse` represents a collection of movies, such as a series or franchise.
/// It includes information about the collection and the movies it contains.
final class MovieCollectionSingleResponse: Identifiable, Sendable {
  /// The unique identifier of the collection.
  let id: Int
  /// The name of the collection.
  let name: String?
  /// The path to the collection's poster image.
  let posterPath: String?
  /// The path to the collection's backdrop image.
  let backdropPath: String?
  /// An array of movies that are part of the collection.
  let movies: [MovieDetailSingleResponse] = []
  
  /// Initializes a new `MovieCollectionSingleResponse` instance.
  /// - Parameters:
  ///   - id: The unique identifier of the collection.
  ///   - name: The name of the collection.
  ///   - posterPath: The path to the collection's poster image.
  ///   - backdropPath: The path to the collection's backdrop image.
  init(id: Int, name: String?, posterPath: String?, backdropPath: String?) {
    self.id = id
    self.name = name
    self.posterPath = posterPath
    self.backdropPath = backdropPath
  }
}

extension MovieCollectionSingleResponse: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case posterPath = "poster_path"
    case backdropPath = "backdrop_path"
  }
}
