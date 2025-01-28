//
//  FilmatchPaths.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/1/25.
//

import Foundation

enum FilmatchGoPaths {
  case userAuth
  case userContent
  case visitTvIdStatus(DiscoverTvSeriesItem.ID)
  case visitMovieIdStatus(DiscoverMovieItem.ID)
  case visitedMovie
  case visitedTv
  case userIdMovie(Int)
  case userIdTv(Int)
  case health
  
  var stringValue: String {
    switch self {
    case .userAuth: "/user/auth"
    case .userContent: "/user/content"
    case .visitTvIdStatus(let id): "/visit/tv/\(id)/status"
    case .visitMovieIdStatus(let id): "/visit/movie/\(id)/status"
    case .visitedMovie: "/visited/movie"
    case .visitedTv: "/visited/tv"
    case .userIdMovie(let id): "/user/\(id)/movie"
    case .userIdTv(let id): "/user/\(id)/tv"
    case .health: "/health"
    }
  }
}
