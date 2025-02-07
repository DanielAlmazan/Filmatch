//
//  FilmatchGoDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 28/1/25.
//

import Foundation

@MainActor
protocol FilmatchGoDatasource {
  func auth() async -> Result<FilmatchUser, Error>
  func markMediaAsVisited(for media: any DiscoverItem, as status: InterestStatus) async
  func getMovieVisitStatus() async
  func getTvVisitStatus() async
  func getTvVisitsByIds() async
  func getMovieVisitsByIds() async
}
