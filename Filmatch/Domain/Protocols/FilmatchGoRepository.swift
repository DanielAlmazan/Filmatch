//
//  FilmatchGoRepository.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 28/1/25.
//

import Foundation

@MainActor
protocol FilmatchGoRepository {
  func auth() async -> Result<FilmatchUser, Error>
  func markMediaAsVisited() async
  func getMovieVisitStatus() async
  func getTvVisitStatus() async
  func getTvVisitsByIds() async
  func getMovieVisitsByIds() async
}
