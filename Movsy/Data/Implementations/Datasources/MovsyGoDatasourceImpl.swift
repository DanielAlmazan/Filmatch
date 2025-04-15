//
//  MovsyGoDatasourceImpl.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 28/1/25.
//

import Foundation

final class MovsyGoDatasourceImpl: MovsyGoDatasource {
  let client: MovsyClient
  
  init(client: MovsyClient) {
    self.client = client
  }
  
  func auth() async -> Result<MovsyUserResponse, Error> {
    let data = await self.client.request(path: .userAuth, method: .POST)
    
    switch data {
    case .success(let success):
      do {
        let loginResponse = try JSONDecoder().decode(
          MovsyGoUserResponse.self, from: success)
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
      print("Error marking media as visited: \(error)")
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
      queryParams: [.ids(ids)]
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
      queryParams: [.ids(ids)]
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
      queryParams: [.filtersHash(hash)]
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
  
  func getUserVisitedMoviesByStatus(for uid: String, as status: InterestStatus, containing query: String?, at page: Int) async -> Result<DiscoverMoviesResponse, Error> {
    var queryParams: [MovsyGoQueryParam] = [
      .interestStatus(status),
      .page(page)
    ]

    if let query, !query.isEmpty {
      queryParams.append(.query(query))
    }

    let result = await client.request(
      path: .userVisitedMoviesList(uid),
      method: .GET,
      queryParams: queryParams
    )
    
    switch result {
    case .success(let data):
      do {
        let response = try JSONDecoder().decode(DiscoverMoviesResponse.self, from: data)
        return .success(response)
      } catch {
        return .failure(error)
      }
    case .failure(let error):
      return .failure(error)
    }
  }
  
  func getUserVisitedTvSeriesByStatus(for uid: String, as status: InterestStatus, containing query: String?, at page: Int) async -> Result<DiscoverTvSeriesResponse, Error> {
    var queryParams: [MovsyGoQueryParam] = [
      .interestStatus(status),
      .page(page)
    ]

    if let query, !query.isEmpty {
      queryParams.append(.query(query))
    }

    let result = await client.request(
      path: .userVisitedTvList(uid),
      method: .GET,
      queryParams: queryParams
    )
    
    switch result {
    case .success(let data):
      do {
        let response = try JSONDecoder().decode(DiscoverTvSeriesResponse.self, from: data)
        return .success(response)
      } catch {
        return .failure(error)
      }
    case .failure(let error):
      return .failure(error)
    }
  }
  
  func getUserFriends(at page: Int) async -> Result<FriendshipsResponse, Error> {
    let result = await client.request(
      path: .friends,
      method: .GET,
      queryParams: [
        .page(page)
      ]
    )
    
    switch result {
    case .success(let data):
      do {
        let response = try JSONDecoder().decode(FriendshipsResponse.self, from: data)
        return .success(response)
      } catch {
        return .failure(error)
      }
    case .failure(let error):
      print("Error getting friends: \(error)")
      return .failure(error)
    }
  }
  
  func getUserFriendRequests(at page: Int) async -> Result<FriendshipsResponse, Error> {
    let result = await client.request(
      path: .friendship,
      method: .GET,
      queryParams: [
        .page(page)
      ]
    )
    
    switch result {
    case .success(let data):
      do {
        let response = try JSONDecoder().decode(FriendshipsResponse.self, from: data)
        return .success(response)
      } catch {
        print("Error getting friend requests: \(error)")
        return .failure(error)
      }
    case .failure(let error):
      print("Error getting friend requests: \(error)")
      return .failure(error)
    }
  }
  
  func searchUsers(containing query: String, at page: Int, with statuses: [FriendshipStatus]?, sortedBy status: FriendshipStatus?) async -> Result<SearchUsersResponse, Error> {
    var queryParams = [MovsyGoQueryParam]()
    
    queryParams.append(.query(query))
    queryParams.append(.page(page))
    
    if let statuses = statuses {
      queryParams.append(.friendshipStatuses(statuses))
    }
    
    if let status = status {
      queryParams.append(.sortByStatusFirst(status))
    }
    
    let result = await client.request(
      path: .search,
      method: .GET,
      queryParams: queryParams
    )
    
    switch result {
    case .success(let data):
      do {
        let response = try JSONDecoder().decode(SearchUsersResponse.self, from: data)
        return .success(response)
      } catch {
        return .failure(error)
      }
    case .failure(let error):
      return .failure(error)
    }
  }
  
  func sendFriendshipRequest(to uid: String) async -> Result<Void, Error> {
    let sendFriendshipBody = SendFriendshipBody(userUid: uid)
    let data: Data
    
    do {
      data = try JSONEncoder().encode(sendFriendshipBody)
    } catch {
      print("Error decoding SendFriendshipBody: \(error)")
      return .failure(error)
    }
    
    let result = await client.request(
      path: .friendship,
      method: .POST,
      body: data
    )
    
    return switch result {
    case .success(_):
        .success(())
    case .failure(let error):
        .failure(error)
    }
  }
  
  func acceptFriendshipRequest(from uid: String) async -> Result<Void, Error> {
    let acceptFriendshipRequestBody = AcceptFriendshipRequestBody(friendUid: uid)
    let data: Data
    
    do {
      data = try JSONEncoder().encode(acceptFriendshipRequestBody)
    } catch {
      print("Error decoding AcceptFriendshipRequestBody: \(error)")
      return .failure(error)
    }
    
    let result = await client.request(
      path: .friendship,
      method: .PUT,
      body: data
    )
    
    switch result {
    case .success(_):
      return .success(())
    case .failure(let error):
      return .failure(error)
    }
  }
  
  func removeFriendship(with uid: String) async -> Result<Void, Error> {
    let deleteFriendshipBody = DeleteFriendshipBody(friendUid: uid)
    let data: Data
    
    do {
      data = try JSONEncoder().encode(deleteFriendshipBody)
    } catch {
      print("Error decoding AcceptFriendshipRequestBody: \(error)")
      return .failure(error)
    }
    
    let result = await client.request(
      path: .friendship,
      method: .DELETE,
      body: data
    )
    
    switch result {
    case .success(_):
      return .success(())
    case .failure(let error):
      return .failure(error)
    }
  }
  
  func blockUser(with uid: String) async -> Result<Void, Error> {
    let result = await client.request(path: .block(uid), method: .POST)
    
    switch result {
    case .success(_):
      return .success(())
    case .failure(let error):
      return .failure(error)
    }
  }
  
  func unblockUser(with uid: String) async -> Result<Void, Error> {
    let result = await client.request(path: .block(uid), method: .DELETE)
    
    switch result {
    case .success(_):
      return .success(())
    case .failure(let error):
      return .failure(error)
    }
  }
  
  func getUserMovieMatchesGroupedByFriends(containing query: String?, at page: Int) async -> Result<MovieMatchesGroupedByFriendsResponse, Error> {
    // Build the query params
    var queryParams: [MovsyGoQueryParam] = [
      .page(page),
      .resultsPerPage(10)
    ]
    if let query, !query.isEmpty {
      queryParams.append(.query(query))
    }

    let result = await client.request(
      path: .userMatchesMovies,
      method: .GET,
      queryParams: queryParams
    )

    switch result {
    case .success(let response):
      do {
        let matchesResponse = try JSONDecoder().decode(MovieMatchesGroupedByFriendsResponse.self, from: response)
        return .success(matchesResponse)
      } catch {
        print("Error decoding MovieMatchesGroupedByFriendsResponse: \(error)")
        return .failure(error)
      }
    case .failure(let error):
      print("Error decoding MovieMatchesGroupedByFriendsResponse: \(error)")
      return .failure(error)
    }
  }

  func getUserTvSeriesMatchesGroupedByFriends(containing query: String?, at page: Int) async -> Result<TvSeriesMatchesGroupedByFriendsResponse, Error> {
    var queryParams: [MovsyGoQueryParam] = [
      .page(page),
      .resultsPerPage(10)
    ]
    if let query, !query.isEmpty {
      queryParams.append(.query(query))
    }
    
    let result = await client.request(
      path: .userMatchesTvSeries,
      method: .GET,
      queryParams: queryParams
    )
    
    switch result {
    case .success(let response):
      do {
        let matchesResponse = try JSONDecoder().decode(TvSeriesMatchesGroupedByFriendsResponse.self, from: response)
        return .success(matchesResponse)
      } catch {
        print("Error decoding TvSeriesMatchesGroupedByFriendsResponse: \(error)")
        return .failure(error)
      }
    case .failure(let error):
      print("Error decoding TvSeriesMatchesGroupedByFriendsResponse: \(error)")
      return .failure(error)
    }
  }
  
  func getMovieMatchesByFriendUid(by uid: String, containing query: String?, at page: Int) async -> Result<DetailMovieMatchesResponse, Error> {
    var queryParams: [MovsyGoQueryParam] = [
      .page(page)
    ]
    if let query, !query.isEmpty {
      queryParams.append(.query(query))
    }
    let result = await client.request(
      path: .userMatchesMoviesByUid(uid),
      method: .GET,
      queryParams: queryParams
    )

    switch result {
    case .success(let response):
      do {
        let matchesResponse = try JSONDecoder().decode(DetailMovieMatchesResponse.self, from: response)
        return .success(matchesResponse)
      } catch {
        return .failure(error)
      }
    case .failure(let error):
      return .failure(error)
    }
  }

  func getTvSeriesMatchesByFriendUid(by uid: String, containing query: String?, at page: Int) async -> Result<DetailTvSeriesMatchesResponse, Error> {
    var queryParams: [MovsyGoQueryParam] = [
      .page(page)
    ]
    if let query, !query.isEmpty {
      queryParams.append(.query(query))
    }
    let result = await client.request(
      path: .userMatchesTvSeriesByUid(uid),
      method: .GET,
      queryParams: queryParams
    )

    switch result {
    case .success(let response):
      do {
        let matchesResponse = try JSONDecoder().decode(DetailTvSeriesMatchesResponse.self, from: response)
        return .success(matchesResponse)
      } catch {
        return .failure(error)
      }
    case .failure(let error):
      return .failure(error)
    }
  }
}
