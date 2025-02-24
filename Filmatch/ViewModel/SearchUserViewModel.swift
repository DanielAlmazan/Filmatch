//
//  SearchUserViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import Foundation

@Observable
final class SearchUserViewModel {
  let repository: FilmatchGoRepository
  
  var query: String = ""
  private var currentQuery: String = ""
  var currentPage: Int = 1
  var totalPages: Int = 1
  var isLoading: Bool = false
  var errorMessage: String?
  
  var users: [FilmatchUser]?
  
  init(repository: FilmatchGoRepository) {
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
      setUsers(usersResult.results)
      self.totalPages = usersResult.totalPages
      self.currentPage += 1
    case .failure(let error):
      self.errorMessage = error.localizedDescription
      print("Error searching users containing \(self.query) at page \(currentPage): \(error)")
    }
    
    isLoading = false
  }
  
  private func setUsers(_ users: [FilmatchUser]) {
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
  func handleFriendshipAction(for user: FilmatchUser, action: FriendshipAction) async {
    guard let _ = user.friendshipStatus else { return }
    
    switch action {
    case .sendRequest:
      let result = await repository.sendFriendshipRequest(to: user.uid)
      handleResult(result, message: "Friend request sent")
      
    case .cancelRequest:
      let result = await repository.removeFriendship(with: user.uid)
      handleResult(result, message: "Friend request canceled")
      
    case .acceptRequest:
      let result = await repository.acceptFriendshipRequest(from: user.uid)
      handleResult(result, message: "Friend request accepted")
      
    case .rejectRequest:
      let result = await repository.removeFriendship(with: user.uid)
      handleResult(result, message: "Friend request rejected")
      
    case .deleteFriend:
      let result = await repository.removeFriendship(with: user.uid)
      handleResult(result, message: "Friend deleted")
      
    case .block:
      let result = await repository.blockUser(with: user.uid)
      handleResult(result, message: "User blocked")
      
    case .unblock:
      let result = await repository.unblockUser(with: user.uid)
      handleResult(result, message: "User unblocked")
    }
  }
  
  @MainActor
  private func handleResult(_ result: Result<Void, Error>, message: String) {
    switch result {
    case .success:
      print(message)
    case .failure(let error):
      print("Error: \(error.localizedDescription)")
    }
  }
}
