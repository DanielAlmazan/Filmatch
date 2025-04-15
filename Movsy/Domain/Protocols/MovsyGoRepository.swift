//
//  MovsyGoRepository.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 28/1/25.
//

import Foundation

@MainActor
protocol MovsyGoRepository {
  func auth() async -> Result<MovsyUserResponse, Error>
  func markMediaAsVisited(for media: any DiscoverItem, as status: InterestStatus) async -> Result<Void, Error>
  func getMovieVisitStatus() async
  func getTvVisitStatus() async
  func getTvVisitsByIds(for ids: String) async -> Result<[Int], Error>
  func getMovieVisitsByIds(for ids: String) async -> Result<[Int], Error>
  func createVisitedFiltersHash(for filters: MediaFilters, at maxPage: Int) async -> Result<Void, Error>
  func getLatestVisitedPageByFiltersHash(for hash: String) async -> Result<Int, Error>
  func getUserVisitedMoviesByStatus(for uid: String, as status: InterestStatus, containing query: String?, at page: Int) async -> Result<DiscoverMoviesResponse, Error>
  func getUserVisitedTvSeriesByStatus(for uid: String, as status: InterestStatus, containing query: String?, at page: Int) async -> Result<DiscoverTvSeriesResponse, Error>
  func getUserFriends(at page: Int) async -> Result<FriendshipsResponse, Error>
  func getUserFriendRequests(at page: Int) async -> Result<FriendshipsResponse, Error>
  func searchUsers(containing query: String, at page: Int, with statuses: [FriendshipStatus]?, sortedBy status: FriendshipStatus?) async -> Result<SearchUsersResponse, Error>
  func sendFriendshipRequest(to uid: String) async -> Result<Void, Error>
  func acceptFriendshipRequest(from uid: String) async -> Result<Void, Error>
  func removeFriendship(with uid: String) async -> Result<Void, Error>
  func blockUser(with uid: String) async -> Result<Void, Error>
  func unblockUser(with uid: String) async -> Result<Void, Error>
  func getUserTvSeriesMatchesGroupedByFriends(containing query: String?, at page: Int) async -> Result<TvSeriesMatchesGroupedByFriendsResponse, Error>
  func getUserMovieMatchesGroupedByFriends(containing query: String?, at page: Int) async -> Result<MovieMatchesGroupedByFriendsResponse, Error>
  func getMovieMatchesByFriendUid(by uid: String, containing query: String?, at page: Int) async -> Result<DetailMovieMatchesResponse, Error>
  func getTvSeriesMatchesByFriendUid(by uid: String, containing query: String?, at page: Int) async -> Result<DetailTvSeriesMatchesResponse, Error>
}

extension MovsyGoRepository {
  func searchUsers(containing query: String = "", at page: Int = 1, with statuses: [FriendshipStatus]? = nil, sortedBy status: FriendshipStatus? = nil) async -> Result<SearchUsersResponse, Error> {
    await self.searchUsers(containing: query, at: page, with: statuses, sortedBy: status)
  }

  func getUserVisitedMoviesByStatus(for uid: String, as status: InterestStatus, containing query: String? = nil, at page: Int = 1) async -> Result<DiscoverMoviesResponse, Error> {
    await self.getUserVisitedMoviesByStatus(for: uid, as: status, containing: query, at: page)
  }
  func getUserVisitedTvSeriesByStatus(for uid: String, as status: InterestStatus, containing query: String? = nil, at page: Int = 1) async -> Result<DiscoverTvSeriesResponse, Error> {
    await self.getUserVisitedTvSeriesByStatus(for: uid, as: status, containing: query, at: page)
  }

  func getUserTvSeriesMatchesGroupedByFriends(containing query: String? = nil, at page: Int = 1) async -> Result<TvSeriesMatchesGroupedByFriendsResponse, Error> {
    await self.getUserTvSeriesMatchesGroupedByFriends(containing: query, at: page)
  }

  func getUserMovieMatchesGroupedByFriends(containing query: String? = nil, at page: Int = 1) async -> Result<MovieMatchesGroupedByFriendsResponse, Error> {
    await self.getUserMovieMatchesGroupedByFriends(containing: query, at: page)
  }

  func getMovieMatchesByFriendUid(by uid: String, containing query: String? = nil, at page: Int = 1) async -> Result<DetailMovieMatchesResponse, Error> {
    await self.getMovieMatchesByFriendUid(by: uid, containing: query, at: page)
  }

  func getTvSeriesMatchesByFriendUid(by uid: String, containing query: String? = nil, at page: Int = 1) async -> Result<DetailTvSeriesMatchesResponse, Error> {
    await self.getTvSeriesMatchesByFriendUid(by: uid, containing: query, at: page)
  }
}
