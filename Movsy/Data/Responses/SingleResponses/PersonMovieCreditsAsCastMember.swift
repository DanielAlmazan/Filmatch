//
//  PersonMovieCreditsAsCastMember.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 13/1/25.
//

import Foundation

final class PersonMovieCreditsAsCastMember: Identifiable, Sendable {
  let adult: Bool?
  let backdropPath: String?
  let genreIds: [Genre.ID]?
  let id: Int?
  let originalLanguage: String?
  let originalTitle: String?
  let overview: String?
  let popularity: Double?
  let posterPath: String?
  let releaseDate: Date?
  let title: String?
  let voteAverage: Double?
  let voteCount: Int?
  let character: String?
  let creditId: String?
  let order: Int?

  init(
    adult: Bool?,
    backdropPath: String?,
    genreIds: [Genre.ID]?,
    id: Int?,
    originalLanguage: String?,
    originalTitle: String?,
    overview: String?,
    popularity: Double?,
    posterPath: String?,
    releaseDate: Date?,
    title: String?,
    voteAverage: Double?,
    voteCount: Int?,
    character: String?,
    creditId: String?,
    order: Int?
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
    self.voteAverage = voteAverage
    self.voteCount = voteCount
    self.character = character
    self.creditId = creditId
    self.order = order
  }
}

extension PersonMovieCreditsAsCastMember: Codable {
  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case genreIds = "genre_ids"
    case id
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case overview
    case popularity
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case title
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case character
    case creditId = "credit_id"
    case order
  }

  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let adult = try container.decode(Bool.self, forKey: .adult)
    let backdropPath = try container.decode(String?.self, forKey: .backdropPath)
    let genreIds = try container.decode([Genre.ID].self, forKey: .genreIds)
    let id = try container.decode(Int.self, forKey: .id)
    let originalLanguage = try container.decode(
      String.self, forKey: .originalLanguage)
    let originalTitle = try container.decode(
      String.self, forKey: .originalTitle)
    let overview = try container.decode(String.self, forKey: .overview)
    let popularity = try container.decode(Double.self, forKey: .popularity)
    let posterPath = try container.decode(String?.self, forKey: .posterPath)

    let releaseDateString = try container.decode(
      String?.self, forKey: .releaseDate)
    let releaseDate: Date? = {
      guard let releaseDateString, !releaseDateString.isEmpty else {
        return nil
      }
      return Utilities.dateFormatter.date(from: releaseDateString)
    }()

    let title = try container.decode(String.self, forKey: .title)
    let voteAverage = try container.decode(Double.self, forKey: .voteAverage)
    let voteCount = try container.decode(Int.self, forKey: .voteCount)
    let character = try container.decode(String.self, forKey: .character)
    let creditId = try container.decode(String.self, forKey: .creditId)
    let order = try container.decode(Int.self, forKey: .order)

    self.init(
      adult: adult,
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
      voteAverage: voteAverage,
      voteCount: voteCount,
      character: character,
      creditId: creditId,
      order: order)
  }

  func encode(to encoder: Encoder) throws {
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
    try container.encode(voteAverage, forKey: .voteAverage)
    try container.encode(voteCount, forKey: .voteCount)
    try container.encode(character, forKey: .character)
    try container.encode(creditId, forKey: .creditId)
    try container.encode(order, forKey: .order)
  }
}

extension PersonMovieCreditsAsCastMember: Equatable {
  public static func == (
    lhs: PersonMovieCreditsAsCastMember, rhs: PersonMovieCreditsAsCastMember
  ) -> Bool {
    lhs.id == rhs.id && lhs.character == rhs.character
      && lhs.creditId == rhs.creditId && lhs.order == rhs.order
      && lhs.originalLanguage == rhs.originalLanguage
      && lhs.originalTitle == rhs.originalTitle && lhs.overview == rhs.overview
      && lhs.releaseDate == rhs.releaseDate && lhs.title == rhs.title
  }
}

extension [PersonMovieCreditsAsCastMember] {
  func sortedByOrderOrReleaseDate() -> [PersonMovieCreditsAsCastMember] {
    sorted { lhs, rhs in
      guard let firstOrder = lhs.order,
        let secondOrder = rhs.order,
        firstOrder != secondOrder
      else {
        guard let firstReleaseDate = lhs.releaseDate,
          let secondReleaseDate = rhs.releaseDate
        else {
          return false
        }
        return firstReleaseDate > secondReleaseDate
      }
      return firstOrder < secondOrder
    }
  }
}
