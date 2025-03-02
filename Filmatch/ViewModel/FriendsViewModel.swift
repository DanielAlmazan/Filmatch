//
//  FriendsViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/2/25.
//

import Foundation
import SwiftUI

@Observable
final class FriendsViewModel {
  let otterMatchRepository: OtterMatchGoRepository
  
  // MARK: - Search Items
  var searchText: String = ""
  private var currentSearchText: String?

  // MARK: - Friends Pagination
  var totalFriendsPages: Int = 1
  var currentFriendsPage: Int = 1
  var friends: [OtterMatchUser]?

  // MARK: - Friendship Requests Pagination
  var totalFriendRequestsPages: Int = 1
  var currentFriendRequestsPage: Int = 1
  var friendRequests: [OtterMatchUser]?

  // MARK: - Loading Flags
  var isLoadingFriends: Bool = false
  var isLoadingRequests: Bool = false
  
  init(otterMatchRepository: OtterMatchGoRepository) {
    self.otterMatchRepository = otterMatchRepository
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
    
    let friendsResult = await otterMatchRepository.searchUsers(
      containing: currentSearchText ?? "",
      at: currentFriendsPage,
      with: [.friend]
    )
    
    switch friendsResult {
    case .success(let response):
      friends.setUsers(response.results.toOtterMatchUsers(as: .friend))
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
    
    let friendRequestsResult = await otterMatchRepository.searchUsers(
      containing: currentSearchText ?? "",
      at: currentFriendRequestsPage,
      with: [.received]
    )
    
    switch friendRequestsResult {
    case .success(let response):
      friendRequests.setUsers(response.results.toOtterMatchUsers(as: .received))
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
    for user: Binding<OtterMatchUser>,
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
        await otterMatchRepository.sendFriendshipRequest(to: uid)
      case .cancelRequest:
        await otterMatchRepository.removeFriendship(with: uid)
      case .acceptRequest:
        await otterMatchRepository.acceptFriendshipRequest(from: uid)
      case .rejectRequest:
        await otterMatchRepository.removeFriendship(with: uid)
      case .deleteFriend:
        await otterMatchRepository.removeFriendship(with: uid)
      case .block:
        await otterMatchRepository.blockUser(with: uid)
      case .unblock:
        await otterMatchRepository.unblockUser(with: uid)
      }
      
      if case .failure = result {
        user.wrappedValue.friendshipStatus = oldStatus
      }
    }
  }

  // MARK: Private functions

  private func updateUserFriendshipState(
    for user: Binding<OtterMatchUser>, when action: FriendshipAction
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
