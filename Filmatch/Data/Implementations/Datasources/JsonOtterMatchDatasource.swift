//
//  JsonOtterMatchDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import Foundation

final class JsonOtterMatchDatasource: OtterMatchGoDatasource {
  let client: TMDBJsonClient
  
  init(client: TMDBJsonClient) {
    self.client = client
  }

  func auth() async -> Result<OtterMatchUserResponse, any Error> {
    await client.get("user-auth", responseType: OtterMatchUserResponse.self)
  }
  
  func markMediaAsVisited(for media: any DiscoverItem, as status: InterestStatus) async -> Result<Void, any Error> {
    .success(())
  }
  
  func getMovieVisitStatus() async {
    // Not implemented
  }
  
  func getTvVisitStatus() async {
    // Not implemented
  }
  
  func getTvVisitsByIds(for ids: String) async -> Result<[Int], any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func getMovieVisitsByIds(for ids: String) async -> Result<[Int], any Error> {

    return .failure(RuntimeErrors.notImplemented)
  }
  
  func createVisitedFiltersHash(for filters: MediaFilters, at page: Int) async -> Result<Void, any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func getLatestVisitedPageByFiltersHash(for hash: String) async -> Result<Int, any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func getUserVisitedMoviesByStatus(for uid: String, as status: InterestStatus, containing query: String?, at page: Int) async -> Result<DiscoverMoviesResponse, any Error> {
    await client.get("user-WAy0Ia6xOwVzs6cD0XS434hUFZ02-visited-movies-status\(status.rawValue)-page\(page)", responseType: DiscoverMoviesResponse.self)
  }
  
  func getUserVisitedTvSeriesByStatus(for uid: String, as status: InterestStatus, containing query: String?, at page: Int) async -> Result<DiscoverTvSeriesResponse, any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func getUserFriends(at page: Int) async -> Result<FriendshipsResponse, any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func getUserFriendRequests(at page: Int) async -> Result<FriendshipsResponse, any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func searchUsers(containing query: String, at page: Int, with statuses: [FriendshipStatus]?, sortedBy status: FriendshipStatus?) async -> Result<SearchUsersResponse, any Error> {
    guard let statuses = statuses else { return .failure(RuntimeErrors.notImplemented) }
    return await client.get("search-users-\(statuses.joined())", responseType: SearchUsersResponse.self)
  }
  
  func sendFriendshipRequest(to uid: String) async -> Result<Void, any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func acceptFriendshipRequest(from uid: String) async -> Result<Void, any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func removeFriendship(with uid: String) async -> Result<Void, any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func blockUser(with uid: String) async -> Result<Void, any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func unblockUser(with uid: String) async -> Result<Void, any Error> {
    
    return .failure(RuntimeErrors.notImplemented)
  }
  
  func getUserMovieMatchesGroupedByFriends(containing query: String?, at page: Int) async -> Result<MovieMatchesGroupedByFriendsResponse, any Error> {
    await client.get("user-movie-matches-grouped-page\(page)", responseType: MovieMatchesGroupedByFriendsResponse.self)
  }
  
  func getUserTvSeriesMatchesGroupedByFriends(containing query: String?, at page: Int) async -> Result<TvSeriesMatchesGroupedByFriendsResponse, any Error> {
    await client.get("user-tv-matches-grouped-page\(page)", responseType: TvSeriesMatchesGroupedByFriendsResponse.self)
  }
  
  func getMovieMatchesByFriendUid(by uid: String, containing query: String?, at page: Int) async -> Result<DetailMovieMatchesResponse, any Error> {
    await client.get("movie-matches-with-\(uid)-page\(page)", responseType: DetailMovieMatchesResponse.self)
  }
  
  func getTvSeriesMatchesByFriendUid(by uid: String, containing query: String?, at page: Int) async -> Result<DetailTvSeriesMatchesResponse, any Error> {
    await client.get("tv-matches-with-\(uid)-page\(page)", responseType: DetailTvSeriesMatchesResponse.self)
  }
}
