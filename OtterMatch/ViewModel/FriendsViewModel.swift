//
//  FriendsViewModel.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/2/25.
//

import Foundation

@Observable
final class FriendsViewModel {
  let otterMatchRepository: OtterMatchGoRepository
  
  var areFriendsLoading: Bool = false
  var totalFriendsPages: Int = 1
  var currentFriendsPage: Int = 1
  var friends: [OtterMatchUser]?
  
  init(otterMatchRepository: OtterMatchGoRepository) {
    self.otterMatchRepository = otterMatchRepository
  }
  
  @MainActor
  func loadFriends(at page: Int) async {
    guard self.totalFriendsPages >= page else { return }
    
    areFriendsLoading = true
    
    let friendsResult = await otterMatchRepository.getUserFriends(at: page)
    
    switch friendsResult {
    case .success(let response):
      setFriends(response.results.toOtterMatchUsers())
      self.totalFriendsPages = response.totalPages
    case .failure(let error):
      print(error)
    }
    
    areFriendsLoading = false
  }
  
  private func setFriends(_ friends: [OtterMatchUser]) {
    if self.friends == nil {
      self.friends = friends
    } else {
      self.friends!.append(contentsOf: friends)
    }
  }
}
