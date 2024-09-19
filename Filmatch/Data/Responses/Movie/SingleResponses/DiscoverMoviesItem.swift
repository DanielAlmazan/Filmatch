//
//  DiscoverMoviesItem.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

final class DiscoverMoviesItem: Identifiable, Codable, Sendable, Equatable {
  let adult: Bool
  let backdropPath: String?
  let genreIDS: [Int]
  let id: Int
  let originalLanguage: String
  let originalTitle: String
  let overview: String
  let popularity: Double
  let posterPath: String
  let releaseDate: String
  let title: String
  let video: Bool
  let voteAverage: Double
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

  init(
    adult: Bool, backdropPath: String, genreIDS: [Int], id: Int,
    originalLanguage: String, originalTitle: String, overview: String,
    popularity: Double, posterPath: String, releaseDate: String, title: String,
    video: Bool, voteAverage: Double, voteCount: Int
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

  static func == (lhs: DiscoverMoviesItem, rhs: DiscoverMoviesItem) -> Bool {
    lhs.adult == rhs.adult
      && lhs.backdropPath == rhs.backdropPath
      && lhs.genreIDS == rhs.genreIDS
      && lhs.id == rhs.id
      && lhs.originalLanguage == rhs.originalLanguage
      && lhs.originalTitle == rhs.originalTitle
      && lhs.overview == rhs.overview
      && lhs.popularity == rhs.popularity
      && lhs.posterPath == rhs.posterPath
      && lhs.releaseDate == rhs.releaseDate
      && lhs.title == rhs.title
      && lhs.video == rhs.video
      && lhs.voteAverage == rhs.voteAverage
      && lhs.voteCount == rhs.voteCount
  }

  static let `default` = DiscoverMoviesItem(
    adult: false,
    backdropPath: "/9SSEUrSqhljBMzRe4aBTh17rUaC.jpg",
    genreIDS: [
      27,
      878,
      53,
    ],
    id: 945961,
    originalLanguage: "en",
    originalTitle: "Alien: Romulus",
    overview:
      "While scavenging the deep ends of a derelict space station, a group of young space colonizers come face to face with the most terrifying life form in the universe.",
    popularity: 684.302,
    posterPath: "/b33nnKl1GSFbao4l3fZDDqsMx0F.jpg",
    releaseDate: "2024-08-13",
    title: "Alien: Romulus",
    video: false,
    voteAverage: 7.106,
    voteCount: 95
  )
}
