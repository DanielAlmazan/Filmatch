//
//  FilmatchPaths.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/1/25.
//

import Foundation

enum FilmatchGoPaths {
  case userAuth
  case userVisit
  case userVisitedFilter
  case userVisitTvIdStatus(DiscoverTvSeriesItem.ID)
  case userVisitMovieIdStatus(DiscoverMovieItem.ID)
  case userVisitedMovies
  case userVisitedTv
  case userVisitedIdMovie(String)
  case userVisitedIdTv(String)
  case health
  
  var stringValue: String {
    switch self {
    case .userAuth: "/user/auth"
    case .userVisit: "/user/visit"
    case .userVisitedFilter: "/user/visited/filter"
    case .userVisitTvIdStatus(let id): "/user/visit/tv/\(id)/status"
    case .userVisitMovieIdStatus(let id): "/user/visit/movie/\(id)/status"
    case .userVisitedMovies: "/user/visited/movies"
    case .userVisitedTv: "/user/visited/tv"
    case .userVisitedIdMovie(let id): "/user/visited/\(id)/movies/list"
    case .userVisitedIdTv(let id): "/user/visited/\(id)/tv/list"
    case .health: "/health"
    }
  }
}
