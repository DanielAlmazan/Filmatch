//
//  VisitedMediaRequestBody.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/2/25.
//

import Foundation

enum VisitedMediaRequestBody: Encodable {
  case movie(movie: DiscoverMovieItem, status: InterestStatus)
  case tvShow(tvShow: DiscoverTvSeriesItem, status: InterestStatus)
  
  private enum CodingKeys: String, CodingKey {
    case type
    case status
    case movie = "movie"
    case tvShow = "tv_show"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .movie(movie: let movie, status: let status):
      try container.encode(CodingKeys.movie.rawValue, forKey: .type)
      try container.encode(status.rawValue, forKey: CodingKeys.status)
      try container.encode(movie, forKey: CodingKeys.movie)
    case .tvShow(tvShow: let tvShow, status: let status):
      try container.encode(CodingKeys.tvShow.rawValue, forKey: .type)
      try container.encode(status.rawValue, forKey: CodingKeys.status)
      try container.encode(tvShow, forKey: CodingKeys.tvShow)
    }
  }
}
