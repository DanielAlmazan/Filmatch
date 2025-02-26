//
//  SearchUserViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import Foundation

@Observable
final class SearchUserViewModel {
  let repository: OtterMatchGoRepository
  
  var query: String = ""
  private var currentQuery: String = ""
  var currentPage: Int = 1
  var totalPages: Int = 1
  var isLoading: Bool = false
  var errorMessage: String?
  
  var users: [OtterMatchUser]?
  
  init(repository: OtterMatchGoRepository) {
    self.repository = repository
  }
  
  @MainActor
  func searchUsers() async {
    if self.query != currentQuery {
      resetSearch()
      currentQuery = self.query
    } else if self.query.isEmpty {
      return
    }
    
    guard !isLoading, totalPages >= currentPage, !self.query.isEmpty else { return }
    
    errorMessage = nil
    isLoading = true

    let result = await self.repository.searchUsers(containing: self.query, at: currentPage)

    switch result {
    case .success(let usersResult):
      setUsers(usersResult.results.toOtterMatchUsers())
      self.totalPages = usersResult.totalPages
      self.currentPage += 1
    case .failure(let error):
      self.errorMessage = error.localizedDescription
      print("Error searching users containing \(self.query) at page \(currentPage): \(error)")
    }
    
    isLoading = false
  }
  
  private func setUsers(_ users: [OtterMatchUser]) {
    if self.users == nil {
      self.users = users
    } else {
      self.users!.append(contentsOf: users)
    }
  }
  
  @MainActor
  func resetSearch() {
    self.users = nil
    self.currentPage = 1
    self.totalPages = 1
    self.errorMessage = nil
  }
  
  @MainActor
  func handleFriendshipAction(for user: OtterMatchUser, action: FriendshipAction) async {
    guard let _ = user.friendshipStatus else { return }
    let result: Result<Void, Error>

    switch action {
    case .sendRequest:
      result = await repository.sendFriendshipRequest(to: user.uid)
    case .cancelRequest:
      result = await repository.removeFriendship(with: user.uid)
    case .acceptRequest:
      result = await repository.acceptFriendshipRequest(from: user.uid)
    case .rejectRequest:
      result = await repository.removeFriendship(with: user.uid)
    case .deleteFriend:
      result = await repository.removeFriendship(with: user.uid)
    case .block:
      result = await repository.blockUser(with: user.uid)
    case .unblock:
      result = await repository.unblockUser(with: user.uid)
    }

    switch result {
    case .success:
      updateFriendshipStatus(for: user, with: action)
    case .failure(let error):
      print("Error: \(error.localizedDescription)")
    }
  }

  private func updateFriendshipStatus(for user: OtterMatchUser, with action: FriendshipAction) {
    guard let index = users?.firstIndex(where: { $0.uid == user.uid }) else { return }
    
    switch action {
    case .sendRequest:
      users?[index].friendshipStatus = .sent
    case .rejectRequest, .cancelRequest, .deleteFriend:
      users?[index].friendshipStatus = .notRelated
    case .acceptRequest:
      users?[index].friendshipStatus = .friend
    case .block:
      users?[index].friendshipStatus = .blocked
    case .unblock:
      users?[index].friendshipStatus = .notRelated
    }
  }
}
