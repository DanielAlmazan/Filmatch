//
//  SearchUserViewModel.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import Foundation
import SwiftUICore

@Observable
final class SearchUserViewModel {
  let repository: MovsyGoRepository

  var query: String = ""
  private var currentQuery: String = ""
  var currentPage: Int = 1
  var totalPages: Int = 1
  var isLoading: Bool = false
  var errorMessage: String?

  var users: [MovsyUser]?

  init(repository: MovsyGoRepository) {
    self.repository = repository
  }

  @MainActor
  func searchUsers() async {
    print("Searching users for \(self.query) at page \(currentPage)...")
    if self.query != currentQuery {
      resetSearch()
      currentQuery = self.query
    } else if self.query.isEmpty {
      return
    }

    guard !isLoading, !self.query.isEmpty else { return }

    errorMessage = nil
    isLoading = true

    let result = await self.repository.searchUsers(containing: self.query, at: currentPage)

    switch result {
    case .success(let usersResult):
      self.users.setUsers(usersResult.results.toMovsyUsers())
      self.totalPages = usersResult.totalPages
      print("Total results: \(usersResult.totalResults)")
    case .failure(let error):
      self.errorMessage = error.localizedDescription
      print("Error searching users containing \(self.query) at page \(currentPage): \(error)")
    }
    print("Total: \(String(describing: self.users?.count))")

    isLoading = false
  }

  @MainActor
  func loadMoreResults() async {
    guard !isLoading, totalPages > currentPage else { return }
    currentPage += 1
    await searchUsers()
  }

  @MainActor
  func resetSearch() {
    self.users = nil
    self.currentPage = 1
    self.totalPages = 1
    self.errorMessage = nil
  }

  @MainActor
  func handleFriendshipAction(
    for user: MovsyUser,
    do action: FriendshipAction,
  ) {
    let uid = user.uid
//    let oldStatus = user.friendshipStatus

    updateUserFriendshipState(for: user, when: action)

    Task {
      let result: Result<Void, Error> = switch action {
      case .sendRequest:
        await repository.sendFriendshipRequest(to: uid)
      case .cancelRequest, .rejectRequest, .deleteFriend:
        await repository.removeFriendship(with: uid)
      case .acceptRequest:
        await repository.acceptFriendshipRequest(from: uid)
      case .block:
        await repository.blockUser(with: uid)
      case .unblock:
        await repository.unblockUser(with: uid)
      }

      if case .failure = result {
        updateUserFriendshipState(for: user, when: action)
      }
    }
  }

  private func updateUserFriendshipState(
    for user: MovsyUser, when action: FriendshipAction
  ) {
    if let index = users?.firstIndex(of: user) {
      self.users![index].friendshipStatus =
      switch action {
      case .sendRequest:
          .sent
      case .rejectRequest, .cancelRequest, .deleteFriend:
          .notRelated
      case .acceptRequest:
          .friend
      case .block:
          .blocked
      case .unblock:
          .notRelated
      }
    }
  }
}
