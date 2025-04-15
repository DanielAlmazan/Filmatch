//
//  DiscoverMovieItem.swift
//  Movsy
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
  let releaseDate: Date?
  let title: String
  let video: Bool
  let voteAverage: Double
  let voteCount: Int
  
  var getTitle: String {
    self.title
  }
  
  var getReleaseDate: String {
    guard let date = self.releaseDate else { return "unknown" }
    return "\(Calendar.current.component(.year, from: date))"
  }

  var status: InterestStatus?

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
//    releaseDate: "2024-08-13",
    releaseDate: Date(timeIntervalSince1970: 1723569460),
    title: "Alien: Romulus",
    video: false,
    voteAverage: 7.106,
    voteCount: 95,
    status: .interested
  )
}

extension DiscoverMovieItem: Encodable {
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
