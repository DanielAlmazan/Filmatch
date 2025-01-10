//
//  MovieSearchResultSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import Foundation

/// `MovieSearchResultSingleResponse` represents a single movie result from a search query.
/// It contains basic information about the movie.
final class MovieSearchResultSingleResponse: Codable {
  /// Indicates whether the movie is for adults only.
  let adult: Bool
  /// The path to the backdrop image of the movie.
  let backdropPath: String
  /// An array of genre IDs associated with the movie.
  let genreIds: [Int]
  /// The unique identifier of the movie.
  let id: Int
  /// The original language of the movie.
  let originalLanguage: String
  /// The original title of the movie.
  let originalTitle: String
  /// A brief overview or synopsis of the movie.
  let overview: String
  /// The popularity score of the movie.
  let popularity: Double
  /// The path to the poster image of the movie.
  let posterPath: String
  /// The release date of the movie.
  let releaseDate: String
  /// The title of the movie.
  let title: String
  /// Indicates whether the movie has a video associated.
  let video: Bool
  /// The average vote score of the movie.
  let voteAverage: Double
  /// The total number of votes the movie has received.
  let voteCount: Int
  
  enum CodingKeys: String, CodingKey {
    case adult, id, overview, popularity, title, video
    case backdropPath = "backdrop_path"
    case genreIds = "genre_ids"
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
}
