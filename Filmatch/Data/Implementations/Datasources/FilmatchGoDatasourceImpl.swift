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

  func markMediaAsVisited(for media: any DiscoverItem, as status: InterestStatus) async {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(Utilities.dateFormatter)
    
    var body: VisitedMediaRequestBody {
      switch media.mediaType {
      case .movie:
        VisitedMediaRequestBody.movie(movie: media as! DiscoverMovieItem, status: status)
      case .tvSeries:
        VisitedMediaRequestBody.tvShow(tvShow: media as! DiscoverTvSeriesItem, status: status)
      }
    }
    
    let encodedBody: Data
    
    do {
      encodedBody = try encoder.encode(body)
      print(String(data: encodedBody, encoding: .utf8) ?? "Error converting to string")
    } catch {
      print("Error encoding body: \(error)")
      return
    }
    
    let result = await self.client.request(path: .userContent, method: .POST, queryParams: nil, body: encodedBody, acceptedStatusCodes: 200...201)
    
    switch result {
    case .success(let message):
      print(message)
    case .failure(let error):
      print(error)
    }
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
