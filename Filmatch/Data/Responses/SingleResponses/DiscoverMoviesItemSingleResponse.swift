//
//  DiscoverMoviesItemSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

/// `DiscoverMoviesItem` represents a movie item in the list of discovered movies.
/// It includes basic information about the movie.
final class DiscoverMoviesItemSingleResponse: Identifiable, Codable, Sendable {
  /// Indicates whether the movie is for adults only.
  let adult: Bool
  /// The path to the backdrop image of the movie.
  let backdropPath: String?
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
  let releaseDate: String?
  /// The title of the movie.
  let title: String
  /// Indicates whether the movie has a video associated.
  let video: Bool
  /// The average vote score of the movie.
  let voteAverage: Double
  /// The total number of votes the movie has received.
  let voteCount: Int
  
  enum CodingKeys: String, CodingKey {
    case adult, id, title, video, overview, popularity
    case backdropPath = "backdrop_path"
    case genreIds = "genre_ids"
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
  
  /// Initializes a new `DiscoverMoviesItem` instance.
  /// - Parameters:
  ///   - adult: Indicates whether the movie is for adults only.
  ///   - backdropPath: The path to the backdrop image of the movie.
  ///   - genreIds: An array of genre IDs associated with the movie.
  ///   - id: The unique identifier of the movie.
  ///   - originalLanguage: The original language of the movie.
  ///   - originalTitle: The original title of the movie.
  ///   - overview: A brief overview or synopsis of the movie.
  ///   - popularity: The popularity score of the movie.
  ///   - posterPath: The path to the poster image of the movie.
  ///   - releaseDate: The release date of the movie.
  ///   - title: The title of the movie.
  ///   - video: Indicates whether the movie has a video associated.
  ///   - voteAverage: The average vote score of the movie.
  ///   - voteCount: The total number of votes the movie has received.
  init(
    adult: Bool,
    backdropPath: String,
    genreIds: [Int],
    id: Int,
    originalLanguage: String,
    originalTitle: String,
    overview: String,
    popularity: Double,
    posterPath: String,
    releaseDate: String?,
    title: String,
    video: Bool,
    voteAverage: Double,
    voteCount: Int
  ) {
    self.adult = adult
    self.backdropPath = backdropPath
    self.genreIds = genreIds
    self.id = id
    self.originalLanguage = originalLanguage
    self.originalTitle = originalTitle
    self.overview = overview
    self.popularity = popularity
    self.posterPath = posterPath
    self.releaseDate = releaseDate
    self.title = title
    self.video = video
    self.voteAverage = voteAverage
    self.voteCount = voteCount
  }
}

// MARK: - Equatable Conformance
extension DiscoverMoviesItemSingleResponse: Equatable {
  static func == (lhs: DiscoverMoviesItemSingleResponse, rhs: DiscoverMoviesItemSingleResponse) -> Bool {
    lhs.adult == rhs.adult &&
    lhs.backdropPath == rhs.backdropPath &&
    lhs.genreIds == rhs.genreIds &&
    lhs.id == rhs.id &&
    lhs.originalLanguage == rhs.originalLanguage &&
    lhs.originalTitle == rhs.originalTitle &&
    lhs.overview == rhs.overview &&
    lhs.popularity == rhs.popularity &&
    lhs.posterPath == rhs.posterPath &&
    lhs.releaseDate == rhs.releaseDate &&
    lhs.title == rhs.title &&
    lhs.video == rhs.video &&
    lhs.voteAverage == rhs.voteAverage &&
    lhs.voteCount == rhs.voteCount
  }
}

extension DiscoverMoviesItemSingleResponse: CustomStringConvertible {
  public var description: String {
    "{ Movie: id: \(self.id), title: \(self.title) }"
  }
}
