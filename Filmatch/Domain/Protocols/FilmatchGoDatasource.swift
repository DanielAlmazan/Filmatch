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
  func markMediaAsVisited(for media: any DiscoverItem, as status: InterestStatus) async -> Result<Void, Error>
  func getMovieVisitStatus() async
  func getTvVisitStatus() async
  func getTvVisitsByIds(for ids: String) async -> Result<[Int], Error>
  func getMovieVisitsByIds(for ids: String) async -> Result<[Int], Error>
  func createVisitedFiltersHash(for filters: MediaFilters, at page: Int) async -> Result<Void, Error>
  func getLatestVisitedPageByFiltersHash(for hash: String) async -> Result<Int, Error>
  func getUserVisitedMoviesByStatus(for uid: String, as status: InterestStatus, at page: Int) async -> Result<[DiscoverMovieItem], Error>
  func getUserVisitedTvSeriesByStatus(for uid: String, as status: InterestStatus, at page: Int) async -> Result<[DiscoverTvSeriesItem], Error>
}
