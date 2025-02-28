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
  
  func onResultRemoval(user: OtterMatchUser) {
    if users != nil, let index = users!.firstIndex(of: user) {
      users!.remove(at: index)
    }
  }
}
