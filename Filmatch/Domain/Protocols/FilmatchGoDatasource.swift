//
//  FilmatchGoDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 28/1/25.
//

import Foundation

@MainActor
protocol FilmatchGoDatasource {
  func auth() async -> Result<FilmatchUserResponse, Error>
  func markMediaAsVisited(for media: any DiscoverItem, as status: InterestStatus) async -> Result<Void, Error>
  func getMovieVisitStatus() async
  func getTvVisitStatus() async
  func getTvVisitsByIds(for ids: String) async -> Result<[Int], Error>
  func getMovieVisitsByIds(for ids: String) async -> Result<[Int], Error>
  func createVisitedFiltersHash(for filters: MediaFilters, at page: Int) async -> Result<Void, Error>
  func getLatestVisitedPageByFiltersHash(for hash: String) async -> Result<Int, Error>
  func getUserVisitedMoviesByStatus(for uid: String, as status: InterestStatus, at page: Int) async -> Result<[DiscoverMovieItem], Error>
  func getUserVisitedTvSeriesByStatus(for uid: String, as status: InterestStatus, at page: Int) async -> Result<[DiscoverTvSeriesItem], Error>
  func getUserFriends(at page: Int) async -> Result<FriendshipsResponse, Error>
  func searchUsers(containing query: String, at page: Int) async -> Result<SearchUsersResponse, Error>
  func sendFriendshipRequest(to uid: String) async -> Result<Void, Error>
  func acceptFriendshipRequest(from uid: String) async -> Result<Void, Error>
  func removeFriendship(with uid: String) async -> Result<Void, Error>
  func blockUser(with uid: String) async -> Result<Void, Error>
  func unblockUser(with uid: String) async -> Result<Void, Error>
}
