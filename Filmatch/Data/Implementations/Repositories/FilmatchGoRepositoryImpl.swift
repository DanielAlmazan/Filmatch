//
//  FilmatchGoRepositoryImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 28/1/25.
//

import Foundation

@Observable final class FilmatchGoRepositoryImpl: FilmatchGoRepository {
  let datasource: FilmatchGoDatasource
  
  init(datasource: FilmatchGoDatasource) {
    self.datasource = datasource
  }
  
  func auth() async -> Result<FilmatchUser, any Error> {
    await self.datasource.auth()
  }
  
  func markMediaAsVisited(for media: any DiscoverItem, as status: InterestStatus) async -> Result<Void, Error> {
    await self.datasource.markMediaAsVisited(for: media, as: status)
  }
  
  func getMovieVisitStatus() async {
    await self.datasource.getMovieVisitStatus()
  }
  
  func getTvVisitStatus() async {
    await self.datasource.getTvVisitStatus()
  }
  
  func getTvVisitsByIds(for ids: String) async -> Result<[Int], Error> {
    await self.datasource.getTvVisitsByIds(for: ids)
  }
  
  func getMovieVisitsByIds(for ids: String) async -> Result<[Int], Error> {
    await self.datasource.getMovieVisitsByIds(for: ids)
  }
  
  func createVisitedFiltersHash(for filters: MediaFilters, at maxPage: Int = 1) async -> Result<Void, Error> {
    await self.datasource.createVisitedFiltersHash(for: filters, at: maxPage)
  }
  
  func getLatestVisitedPageByFiltersHash(for hash: String) async -> Result<Int, Error> {
    await self.datasource.getLatestVisitedPageByFiltersHash(for: hash)
  }
}
