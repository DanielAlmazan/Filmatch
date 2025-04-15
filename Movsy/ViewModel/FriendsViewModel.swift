//
//  FriendsViewModel.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 26/2/25.
//

import Foundation
import SwiftUI

@Observable
final class FriendsViewModel {
  let movsyRepository: MovsyGoRepository
  
  // MARK: - Search Items
  var searchText: String = ""
  private var currentSearchText: String?

  // MARK: - Friends Pagination
  var totalFriendsPages: Int = 1
  var currentFriendsPage: Int = 1
  var friends: [MovsyUser]?

  // MARK: - Friendship Requests Pagination
  var totalFriendRequestsPages: Int = 1
  var currentFriendRequestsPage: Int = 1
  var friendRequests: [MovsyUser]?

  // MARK: - Loading Flags
  var isLoadingFriends: Bool = false
  var isLoadingRequests: Bool = false
  
  init(movsyRepository: MovsyGoRepository) {
    self.movsyRepository = movsyRepository
  }

  // MARK: - Public functions

  @MainActor
  func searchUsers() async {
    guard currentSearchText != searchText || currentSearchText == nil else { return }

    currentSearchText = searchText
    resetFriends()
    resetFriendRequests()

    await loadFriends()
    await loadFriendRequests()
  }

  @MainActor
  func loadFriends() async {
    guard totalFriendsPages >= currentFriendsPage else { return }
    
    isLoadingFriends = true
    
    let friendsResult = await movsyRepository.searchUsers(
      containing: currentSearchText ?? "",
      at: currentFriendsPage,
      with: [.friend]
    )
    
    switch friendsResult {
    case .success(let response):
      friends.setUsers(response.results.toMovsyUsers(as: .friend))
      totalFriendsPages = response.totalPages
    case .failure(let error):
      print(error)
    }
    
    isLoadingFriends = false
  }

  @MainActor
  func loadMoreFriends() async {
    currentFriendsPage += 1
    await loadFriends()
  }
  
  @MainActor
  func loadFriendRequests() async {
    guard totalFriendRequestsPages >= currentFriendRequestsPage else { return }
    
    isLoadingRequests = true
    
    let friendRequestsResult = await movsyRepository.searchUsers(
      containing: currentSearchText ?? "",
      at: currentFriendRequestsPage,
      with: [.received]
    )
    
    switch friendRequestsResult {
    case .success(let response):
      friendRequests.setUsers(response.results.toMovsyUsers(as: .received))
      totalFriendRequestsPages = response.totalPages
    case .failure(let error):
      print(error)
    }
    
    isLoadingRequests = false
  }

  @MainActor
  func loadMoreFriendRequests() async {
    currentFriendRequestsPage += 1
    await loadFriendRequests()
  }
  
  @MainActor
  func handleFriendshipAction(
    for user: Binding<MovsyUser>,
    do action: FriendshipAction
  ) {
    var result: Result<Void, Error>?
    let uid = user.wrappedValue.uid
    let oldStatus = user.wrappedValue.friendshipStatus
    
    updateUserFriendshipState(for: user, when: action)
    
    Task {
      result =
      switch action {
      case .sendRequest:
        await movsyRepository.sendFriendshipRequest(to: uid)
      case .cancelRequest:
        await movsyRepository.removeFriendship(with: uid)
      case .acceptRequest:
        await movsyRepository.acceptFriendshipRequest(from: uid)
      case .rejectRequest:
        await movsyRepository.removeFriendship(with: uid)
      case .deleteFriend:
        await movsyRepository.removeFriendship(with: uid)
      case .block:
        await movsyRepository.blockUser(with: uid)
      case .unblock:
        await movsyRepository.unblockUser(with: uid)
      }
      
      if case .failure = result {
        user.wrappedValue.friendshipStatus = oldStatus
      }
    }
  }

  @MainActor
  func onRefresh() async {
    resetFriends()
    await loadFriends()
    resetFriendRequests()
    await loadFriendRequests()
  }

  // MARK: Private functions

  private func updateUserFriendshipState(
    for user: Binding<MovsyUser>, when action: FriendshipAction
  ) {
    switch action {
    case .sendRequest:
      user.wrappedValue.friendshipStatus = .sent
    case .rejectRequest, .cancelRequest, .deleteFriend:
      user.wrappedValue.friendshipStatus = .notRelated
    case .acceptRequest:
      user.wrappedValue.friendshipStatus = .friend
    case .block:
      user.wrappedValue.friendshipStatus = .blocked
    case .unblock:
      user.wrappedValue.friendshipStatus = .notRelated
    }
  }

  private func resetFriends() {
    friends = nil
    totalFriendsPages = 1
    currentFriendsPage = 1
  }

  private func resetFriendRequests() {
    friendRequests = nil
    totalFriendRequestsPages = 1
    currentFriendRequestsPage = 1
  }
}
