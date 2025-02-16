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
        let loginResponse = try JSONDecoder().decode(
          FilmatchGoUserResponse.self, from: success)
        return .success(loginResponse.user)
      } catch {
        return .failure(error)
      }
    case .failure(let error):
      return .failure(error)
    }
  }

  func markMediaAsVisited(
    for media: any DiscoverItem, as status: InterestStatus
  ) async -> Result<Void, Error> {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(Utilities.dateFormatter)

    var body: VisitedMediaRequestBody {
      switch media.mediaType {
      case .movie:
        VisitedMediaRequestBody.movie(
          movie: media as! DiscoverMovieItem, status: status)
      case .tvSeries:
        VisitedMediaRequestBody.tvShow(
          tvShow: media as! DiscoverTvSeriesItem, status: status)
      }
    }

    let encodedBody: Data

    do {
      encodedBody = try encoder.encode(body)
      print(
        String(data: encodedBody, encoding: .utf8)
          ?? "Error converting to string")
    } catch {
      print("Error encoding body: \(error)")
      return .failure(error)
    }

    let result = await self.client.request(
      path: .userVisit,
      method: .POST,
      body: encodedBody,
      acceptedStatusCodes: [200,201]
    )

    switch result {
    case .success(let message):
      print(message)
      return .success(())
    case .failure(let error):
      print(error)
      return .failure(error)
    }
  }

  func getMovieVisitStatus() async {
    // TODO: Implement
  }

  func getTvVisitStatus() async {
    // TODO: Implement
  }

  func getTvVisitsByIds(for ids: String) async -> Result<[Int], Error> {
    let result = await client.request(
      path: .userVisitedTv,
      method: .GET,
      queryParams: [URLQueryItem(name: "ids", value: ids)]
    )

    switch result {
    case .success(let data):
      do {
        let response = try JSONDecoder().decode(
          VisitedItemsResponse.self, from: data)
        return .success(response.visited)
      } catch {
        return .failure(error)
      }
    case .failure(let error): return .failure(error)
    }
  }

  func getMovieVisitsByIds(for ids: String) async -> Result<[Int], Error> {
    let result = await client.request(
      path: .userVisitedMovies,
      method: .GET,
      queryParams: [URLQueryItem(name: "ids", value: ids)]
    )

    switch result {
    case .success(let data):
      do {
        let response = try JSONDecoder().decode(
          VisitedItemsResponse.self, from: data)
        return .success(response.visited)
      } catch {
        return .failure(error)
      }
    case .failure(let error): return .failure(error)
    }
  }

  func createVisitedFiltersHash(
    for filters: MediaFilters,
    at page: Int = 1
  ) async -> Result<Void, Error> {
    do {
      let filtersHash = filters.filtersHash()
      let body = CreateVisitedFiltersHashBody(filtersHash: filtersHash, page: page)
      let data = try JSONEncoder().encode(body)

      let result = await client.request(
        path: .userVisitedFilter, method: .POST, body: data)

      return switch result {
      case .success(_): .success(())
      case .failure(let error): .failure(error)
      }
    } catch {
      return .failure(error)
    }
  }

  func getLatestVisitedPageByFiltersHash(for hash: String) async -> Result<Int, Error> {
    let result = await client.request(
      path: .userVisitedFilter,
      method: .GET,
      queryParams: [.init(name: "filters_hash", value: hash)]
    )

    switch result {
    case .success(let data):
      do {
        let response = try JSONDecoder().decode(
          LatestPageByVisitedFiltersHashResponse.self, from: data)
        return .success(response.data.latestPage)
      } catch {
        return .failure(error)
      }
    case .failure(let error): return .failure(error)
    }
  }
}
