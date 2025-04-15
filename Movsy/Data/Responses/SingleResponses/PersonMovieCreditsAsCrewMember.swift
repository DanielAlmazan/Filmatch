//
//  PersonMovieCreditsAsCrewMember.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 13/1/25.
//

import Foundation

final class PersonMovieCreditsAsCrewMember: Identifiable, Sendable {
  let adult: Bool?
  let backdropPath: String?
  let genreIds: [Genre.ID]
  let id: Int?
  let originalLanguage: String?
  let originalTitle: String?
  let overview: String?
  let popularity: Double?
  let posterPath: String?
  let releaseDate: Date?
  let title: String?
  let video: Bool?
  let voteAverage: Double?
  let voteCount: Int?
  let creditId: String?
  let department: String?
  let job: String?
  
  init(adult: Bool?,
       backdropPath: String?,
       genreIds: [Genre.ID],
       id: Int?,
       originalLanguage: String?,
       originalTitle: String?,
       overview: String?,
       popularity: Double?,
       posterPath: String?,
       releaseDate: Date?,
       title: String?,
       video: Bool?,
       voteAverage: Double?,
       voteCount: Int?,
       creditId: String?,
       department: String?,
       job: String?) {
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
    self.creditId = creditId
    self.department = department
    self.job = job
  }
}

extension PersonMovieCreditsAsCrewMember: Codable {
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
    case video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
    case creditId = "credit_id"
    case department
    case job
  }
  
  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let adult = try container.decode(Bool?.self, forKey: .adult)
    let backdropPath = try container.decode(String?.self, forKey: .backdropPath)
    let genreIds = try container.decode([Genre.ID].self, forKey: .genreIds)
    let id = try container.decode(Int?.self, forKey: .id)
    let originalLanguage = try container.decode(String?.self, forKey: .originalLanguage)
    let originalTitle = try container.decode(String?.self, forKey: .originalTitle)
    let overview = try container.decode(String?.self, forKey: .overview)
    let popularity = try container.decode(Double?.self, forKey: .popularity)
    let posterPath = try container.decode(String?.self, forKey: .posterPath)
    
    let releaseDateString = try container.decode(String?.self, forKey: .releaseDate)
    let releaseDate: Date? = {
      guard let releaseDateString, !releaseDateString.isEmpty else { return nil }
      return Utilities.dateFormatter.date(from: releaseDateString)
    }()

    let title = try container.decode(String?.self, forKey: .title)
    let video = try container.decode(Bool?.self, forKey: .video)
    let voteAverage = try container.decode(Double?.self, forKey: .voteAverage)
    let voteCount = try container.decode(Int?.self, forKey: .voteCount)
    let creditId = try container.decode(String?.self, forKey: .creditId)
    let department = try container.decode(String?.self, forKey: .department)
    let job = try container.decode(String?.self, forKey: .job)
    
    self.init(adult: adult, backdropPath: backdropPath,
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
              voteCount: voteCount,
              creditId: creditId,
              department: department,
              job: job)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(adult, forKey: .adult)
    try container.encode(backdropPath, forKey: .backdropPath)
    try container.encode(genreIds, forKey: .genreIds)
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
    try container.encode(creditId, forKey: .creditId)
    try container.encode(department, forKey: .department)
    try container.encode(job, forKey: .job)
  }
}

extension [PersonMovieCreditsAsCrewMember] {
  func sortedByPopularityAndJob() -> [PersonMovieCreditsAsCrewMember] {
    sorted { lhs, rhs in
      guard let lhsPopularity = lhs.popularity, let rhsPopularity = rhs.popularity else {
        guard let lhsJob = lhs.job, let rhsJob = rhs.job else {
          return false
        }
        return lhsJob < rhsJob
      }
      return lhsPopularity > rhsPopularity
    }
  }
}
