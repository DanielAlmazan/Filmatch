//
//  DiscoverMovieItem.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/1/25.
//

import Foundation

struct DiscoverMovieItem: DiscoverItem {
  let mediaType: MediaType = .movie
  let adult: Bool
  let backdropPath: String?
  let genreIds: [Int]
  let id: Int
  let originalLanguage: String?
  let originalTitle: String
  let overview: String?
  let popularity: Double
  let posterPath: String?
  let releaseDate: String?
  let title: String
  let video: Bool
  let voteAverage: Double
  let voteCount: Int
  
  var getTitle: String {
    self.title
  }
  
  /// A default instance of `DiscoverMoviesItem` for testing purposes.
  static let `default` = DiscoverMovieItem(
    adult: false,
    backdropPath: "/9SSEUrSqhljBMzRe4aBTh17rUaC.jpg",
    genreIds: [27, 878, 53],
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
