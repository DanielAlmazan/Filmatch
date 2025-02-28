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
  
  var searchText: String = ""
  var filteredFriends: [OtterMatchUser] {
    guard self.friends != nil, !searchText.isEmpty else { return friends ?? [] }
    
    return friends!.filter { friend in
      guard let username = friend.username else { return false }
      return username.lowercased().contains(searchText.lowercased())
    }
  }
  
  var isLoadingFriends: Bool = false
  var totalFriendsPages: Int = 1
  var currentFriendsPage: Int = 1
  var friends: [OtterMatchUser]?
  
  var isLoadingRequests: Bool = false
  var totalFriendRequestsPages: Int = 1
  var currentFriendRequestsPage: Int = 1
  var friendRequests: [OtterMatchUser]?
  
  init(otterMatchRepository: OtterMatchGoRepository) {
    self.otterMatchRepository = otterMatchRepository
  }
  
  @MainActor
  func loadFriends() async {
    guard self.totalFriendsPages >= currentFriendsPage else { return }
    
    isLoadingFriends = true
    
    let friendsResult = await otterMatchRepository.getUserFriends(at: currentFriendsPage)
    
    switch friendsResult {
    case .success(let response):
      self.friends.setUsers(response.results.toOtterMatchUsers())
      self.totalFriendsPages = response.totalPages
      self.currentFriendsPage += 1
    case .failure(let error):
      print(error)
    }
    
    isLoadingFriends = false
  }
  
  @MainActor
  func loadFriendRequests() async {
    let friendRequestsResult = await otterMatchRepository.getUserFriendRequests(at: currentFriendRequestsPage)
    
    switch friendRequestsResult {
    case .success(let response):
      self.friendRequests.setUsers(response.results.toOtterMatchUsers())
      self.totalFriendRequestsPages = response.totalPages
      self.currentFriendRequestsPage += 1
    case .failure(let error):
      print(error)
    }
  }
  
  func onFriendRemoval(user: OtterMatchUser) {
    if self.friends != nil, let index = self.friends!.firstIndex(of: user) {
      self.friends!.remove(at: index)
    }
  }
  
  @MainActor
  func handleFriendshipAction(for user: Binding<OtterMatchUser>, do action: FriendshipAction) async {
    let result: Result<Void, Error>
    let uid = user.wrappedValue.uid
    
    switch action {
    case .sendRequest:
      result = await otterMatchRepository.sendFriendshipRequest(to: uid)
    case .cancelRequest:
      result = await otterMatchRepository.removeFriendship(with: uid)
    case .acceptRequest:
      result = await otterMatchRepository.acceptFriendshipRequest(from: uid)
    case .rejectRequest:
      result = await otterMatchRepository.removeFriendship(with: uid)
    case .deleteFriend:
      result = await otterMatchRepository.removeFriendship(with: uid)
    case .block:
      result = await otterMatchRepository.blockUser(with: uid)
    case .unblock:
      result = await otterMatchRepository.unblockUser(with: uid)
    }
    
    switch result {
    case .success:
      updateUserFriendshipState(for: user, when: action)
    case .failure(let error):
      print("Error: \(error.localizedDescription)")
    }
  }

  private func updateUserFriendshipState(for user: Binding<OtterMatchUser>, when action: FriendshipAction) {
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
}
