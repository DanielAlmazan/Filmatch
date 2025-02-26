//
//  DiscoverMoviesItemSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

/// `DiscoverMoviesItem` represents a movie item in the list of discovered movies.
/// It includes basic information about the movie.
final class DiscoverMoviesItemSingleResponse: Identifiable, Sendable {
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
  let posterPath: String?
  /// The release date of the movie.
  let releaseDate: Date?
  /// The title of the movie.
  let title: String
  /// Indicates whether the movie has a video associated.
  let video: Bool
  /// The average vote score of the movie.
  let voteAverage: Double
  /// The total number of votes the movie has received.
  let voteCount: Int
  
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
    backdropPath: String?,
    genreIds: [Genre.ID],
    id: Int,
    originalLanguage: String,
    originalTitle: String,
    overview: String,
    popularity: Double,
    posterPath: String?,
    releaseDate: Date?,
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

extension DiscoverMoviesItemSingleResponse: Codable {
  private enum CodingKeys: String, CodingKey {
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
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let adult = try container.decode(Bool.self, forKey: .adult)
    let id = try container.decode(Int.self, forKey: .id)
    let title = try container.decode(String.self, forKey: .title)
    let video = try container.decode(Bool.self, forKey: .video)
    let overview = try container.decode(String.self, forKey: .overview)
    let popularity = try container.decode(Double.self, forKey: .popularity)
    let backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    let genreIds = try container.decode([Int].self, forKey: .genreIds)
    let originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
    let originalTitle = try container.decode(String.self, forKey: .originalTitle)
    let posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    
    let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate)
    let releaseDate: Date? = {
      guard let dateStr = releaseDateString, !dateStr.isEmpty else { return nil }
      
      return Utilities.dateFormatter.date(from: dateStr)
    }()
    
    let voteAverage = try container.decode(Double.self, forKey: .voteAverage)
    let voteCount = try container.decode(Int.self, forKey: .voteCount)
    
    self.init(adult: adult,
              backdropPath: backdropPath,
              genreIds: genreIds,
              id: id,
              originalLanguage: originalLanguage,
              originalTitle: originalTitle,
              overview: overview,
              popularity: popularity,
              posterPath: posterPath,
              releaseDate: releaseDate,
              title: title,
              video: video,
              voteAverage: voteAverage,
              voteCount: voteCount)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(adult, forKey: .adult)
    try container.encode(backdropPath, forKey: .backdropPath)
    try container.encode(genreIds, forKey: .genreIds)
    try container.encode(id, forKey: .id)
    try container.encode(originalLanguage, forKey: .originalLanguage)
    try container.encode(originalTitle, forKey: .originalTitle)
    try container.encode(overview, forKey: .overview)
    try container.encode(popularity, forKey: .popularity)
    try container.encode(posterPath, forKey: .posterPath)
    try container.encode(releaseDate, forKey: .releaseDate)
    try container.encode(title, forKey: .title)
    try container.encode(video, forKey: .video)
    try container.encode(voteAverage, forKey: .voteAverage)
    try container.encode(voteCount, forKey: .voteCount)
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
