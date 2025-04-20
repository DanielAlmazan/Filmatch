//
//  MovsyPaths.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 27/1/25.
//

import Foundation

enum MovsyGoPaths {
  case userAuth
  case userVisit
  case userVisitedFilter
  case userVisitTvIdStatus(DiscoverTvSeriesItem.ID)
  case userVisitMovieIdStatus(DiscoverMovieItem.ID)
  case userVisitedMovies
  case userVisitedTv
  case userVisitedMoviesList(String)
  case userVisitedTvList(String)
  case userMatchesMovies
  case userMatchesMoviesByUid(String)
  case userMatchesTvSeries
  case userMatchesTvSeriesByUid(String)
  case friends
  case friendship
  case block(String)
  case search
  case health
  case updateUsername

  var stringValue: String {
    switch self {
    case .userAuth: "/user/auth"
    case .userVisit: "/user/visit"
    case .userVisitedFilter: "/user/visited/filter"
    case .userVisitTvIdStatus(let id): "/user/visit/tv/\(id)/status"
    case .userVisitMovieIdStatus(let id): "/user/visit/movie/\(id)/status"
    case .userVisitedMovies: "/user/visited/movies"
    case .userVisitedTv: "/user/visited/tv"
    case .userVisitedMoviesList(let id): "/user/\(id)/visited/movies/list"
    case .userVisitedTvList(let id): "/user/\(id)/visited/tv/list"
    case .userMatchesMovies: "/user/matches/movies"
    case .userMatchesMoviesByUid(let uid): "/user/matches/movies/\(uid)"
    case .userMatchesTvSeries: "/user/matches/tv"
    case .userMatchesTvSeriesByUid(let uid): "/user/matches/tv/\(uid)"
    case .friends: "/user/friends"
    case .friendship: "/user/friendship"
    case .block(let uid): "/user/block/\(uid)"
    case .search: "/user/search"
    case .health: "/health"
    case .updateUsername: "/user/username"
    }
  }
}

extension MovsyGoPaths: Equatable {
  static func == (lhs: MovsyGoPaths, rhs: MovsyGoPaths) -> Bool {
    lhs.stringValue == rhs.stringValue
  }
}
