//
//  DiscoverMoviesItem.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

/// `DiscoverMoviesItem` represents a movie item in the list of discovered movies.
/// It includes basic information about the movie.
final class DiscoverMoviesItem: Identifiable, Codable, Sendable, Equatable {
  /// Indicates whether the movie is for adults only.
  let adult: Bool
  /// The path to the backdrop image of the movie.
  let backdropPath: String?
  /// An array of genre IDs associated with the movie.
  let genreIDS: [Int]
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
    case adult, id, title, video, overview, popularity
    case backdropPath = "backdrop_path"
    case genreIDS = "genre_ids"
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
  ///   - genreIDS: An array of genre IDs associated with the movie.
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
    genreIDS: [Int],
    id: Int,
    originalLanguage: String,
    originalTitle: String,
    overview: String,
    popularity: Double,
    posterPath: String,
    releaseDate: String,
    title: String,
    video: Bool,
    voteAverage: Double,
    voteCount: Int
  ) {
    self.adult = adult
    self.backdropPath = backdropPath
    self.genreIDS = genreIDS
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
  
  // MARK: - Hashable Conformance
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(adult)
    hasher.combine(backdropPath)
    hasher.combine(genreIDS)
    hasher.combine(id)
    hasher.combine(originalLanguage)
    hasher.combine(originalTitle)
    hasher.combine(overview)
    hasher.combine(popularity)
    hasher.combine(posterPath)
    hasher.combine(releaseDate)
    hasher.combine(title)
    hasher.combine(video)
    hasher.combine(voteAverage)
    hasher.combine(voteCount)
  }
  
  // MARK: - Equatable Conformance
  
  static func == (lhs: DiscoverMoviesItem, rhs: DiscoverMoviesItem) -> Bool {
    lhs.adult == rhs.adult &&
    lhs.backdropPath == rhs.backdropPath &&
    lhs.genreIDS == rhs.genreIDS &&
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
  
  /// A default instance of `DiscoverMoviesItem` for testing purposes.
  static let `default` = DiscoverMoviesItem(
    adult: false,
    backdropPath: "/9SSEUrSqhljBMzRe4aBTh17rUaC.jpg",
    genreIDS: [27, 878, 53],
    id: 945961,
    originalLanguage: "en",
    originalTitle: "Alien: Romulus",
    overview: "While scavenging the deep ends of a derelict space station, a group of young space colonizers come face to face with the most terrifying life form in the universe.",
    popularity: 684.302,
    posterPath: "/b33nnKl1GSFbao4l3fZDDqsMx0F.jpg",
    releaseDate: "2024-08-13",
    title: "Alien: Romulus",
    video: false,
    voteAverage: 7.106,
    voteCount: 95
  )
}
