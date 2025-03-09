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
      self.users.setUsers(usersResult.results.toOtterMatchUsers())
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
}
