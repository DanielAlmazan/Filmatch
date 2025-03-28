//
//  FilmatchGoRepositoryImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 28/1/25.
//

import Foundation

@Observable
final class OtterMatchGoRepositoryImpl: OtterMatchGoRepository {
  private let datasource: OtterMatchGoDatasource
  
  init(datasource: OtterMatchGoDatasource) {
    self.datasource = datasource
  }
  
  func auth() async -> Result<OtterMatchUserResponse, any Error> {
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
  
  func getUserVisitedMoviesByStatus(for uid: String, as status: InterestStatus, at page: Int) async -> Result<DiscoverMoviesResponse, Error> {
    await self.datasource.getUserVisitedMoviesByStatus(for: uid, as: status, at: page)
  }
  
  func getUserVisitedTvSeriesByStatus(for uid: String, as status: InterestStatus, at page: Int) async -> Result<DiscoverTvSeriesResponse, Error> {
    await self.datasource.getUserVisitedTvSeriesByStatus(for: uid, as: status, at: page)
  }
  
  func getUserFriends(at page: Int) async -> Result<FriendshipsResponse, Error> {
    await self.datasource.getUserFriends(at: page)
  }

  func getUserFriendRequests(at page: Int) async -> Result<FriendshipsResponse, Error> {
    await self.datasource.getUserFriendRequests(at: page)
  }

  func searchUsers(containing query: String = "", at page: Int = 1, with statuses: [FriendshipStatus]? = nil, sortedBy status: FriendshipStatus? = nil) async -> Result<SearchUsersResponse, Error> {
    await self.datasource.searchUsers(containing: query, at: page, with: statuses, sortedBy: status)
  }
  
  func sendFriendshipRequest(to uid: String) async -> Result<Void, Error> {
    await self.datasource.sendFriendshipRequest(to: uid)
  }
  
  func acceptFriendshipRequest(from uid: String) async -> Result<Void, Error> {
    await self.datasource.acceptFriendshipRequest(from: uid)
  }
  
  func removeFriendship(with uid: String) async -> Result<Void, Error> {
    await self.datasource.removeFriendship(with: uid)
  }
  
  func blockUser(with uid: String) async -> Result<Void, Error> {
    await self.datasource.blockUser(with: uid)
  }
  
  func unblockUser(with uid: String) async -> Result<Void, Error> {
    await self.datasource.unblockUser(with: uid)
  }
  
  func getUserMovieMatchesGroupedByFriends(containing query: String?, at page: Int) async -> Result<MovieMatchesGroupedByFriendsResponse, Error> {
    await self.datasource.getUserMovieMatchesGroupedByFriends(containing: query, at: page)
  }
  
  func getUserTvSeriesMatchesGroupedByFriends(containing query: String?, at page: Int) async -> Result<TvSeriesMatchesGroupedByFriendsResponse, Error> {
    await self.datasource.getUserTvSeriesMatchesGroupedByFriends(containing: query, at: page)
  }
  
  func getMovieMatchesByFriendUid(by uid: String, containing query: String?, at page: Int) async -> Result<DetailMovieMatchesResponse, Error> {
    await self.datasource.getMovieMatchesByFriendUid(by: uid, containing: query, at: page)
  }
  
  func getTvSeriesMatchesByFriendUid(by uid: String, containing query: String?, at page: Int) async -> Result<DetailTvSeriesMatchesResponse, Error> {
    await self.datasource.getTvSeriesMatchesByFriendUid(by: uid, containing: query, at: page)
  }
}
