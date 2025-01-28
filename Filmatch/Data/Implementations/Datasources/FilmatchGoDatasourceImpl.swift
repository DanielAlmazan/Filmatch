//
//  FilmatchGoDatasourceImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 28/1/25.
//

import Foundation

final class FilmatchGoDatasourceImpl: FilmatchGoDatasource {
  let client: FilmatchClient
  
  init(client: FilmatchClient) {
    self.client = client
  }
  
  func auth() async -> Result<FilmatchUser, Error> {
    let data = await self.client.request(path: .userAuth, method: .POST)
    
    switch data {
    case .success(let success):
      do {
        let loginResponse = try JSONDecoder().decode(FilmatchGoUserResponse.self, from: success)
        return .success(loginResponse.user)
      } catch {
        return .failure(error)
      }
    case .failure(let error):
      return .failure(error)
    }
  }

  func markMediaAsVisited() async {
    // TODO: Implement
  }
  
  func getMovieVisitStatus() async {
    // TODO: Implement
  }
  
  func getTvVisitStatus() async {
    // TODO: Implement
  }
  
  func getTvVisitsByIds() async {
    // TODO: Implement
  }
  
  func getMovieVisitsByIds() async {
    // TODO: Implement
  }
}
