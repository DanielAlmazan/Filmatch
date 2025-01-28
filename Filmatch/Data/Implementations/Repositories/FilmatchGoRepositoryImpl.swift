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
  
  func markMediaAsVisited() async {
    await self.datasource.markMediaAsVisited()
  }
  
  func getMovieVisitStatus() async {
    await self.datasource.getMovieVisitStatus()
  }
  
  func getTvVisitStatus() async {
    await self.datasource.getTvVisitStatus()
  }
  
  func getTvVisitsByIds() async {
    await self.datasource.getTvVisitsByIds()
  }
  
  func getMovieVisitsByIds() async {
    await self.datasource.getMovieVisitsByIds()
  }
}
