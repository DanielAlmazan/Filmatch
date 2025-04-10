//
//  MatchesViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import Foundation

@Observable
final class MatchesViewModel {
  let repository: OtterMatchGoRepository

  var selectedMedia: MediaType = .movie

  private var movieResults: [SimpleFriendMatch]?
  private var currentMoviePage: Int = 1
  private var maxMoviePages: Int = 1

  private var tvResults: [SimpleFriendMatch]?
  private var currentTvPage: Int = 1
  private var maxTvPages: Int = 1
  
  var results: [SimpleFriendMatch]? {
    get {
      switch selectedMedia {
      case .movie: movieResults
      case .tvSeries: tvResults
      }
    }
    set {
      switch selectedMedia {
      case .movie: movieResults = newValue
      case .tvSeries: tvResults = newValue
      }
    }
  }
  
  private var currentFriendsPage: Int {
    get {
      switch selectedMedia {
      case .movie: currentMoviePage
      case .tvSeries: currentTvPage
      }
    }
    set {
      switch selectedMedia {
      case .movie: currentMoviePage = newValue
      case .tvSeries: currentTvPage = newValue
      }
    }
  }
  
  private var maxFriendsPages: Int {
    get {
      switch selectedMedia {
      case .movie: maxMoviePages
      case .tvSeries: maxTvPages
      }
    }
    set {
      switch selectedMedia {
      case .movie: maxMoviePages = newValue
      case .tvSeries: maxTvPages = newValue
      }
    }
  }
  
  var query: String = ""
  private var currentQuery: String = ""
  
  var isLoadingSimpleFriendsMatches: Bool = false
  
  init(repository: OtterMatchGoRepository) {
    self.repository = repository
  }
  
  @MainActor
  func fetchSimpleFriendsMatches() async {
    isLoadingSimpleFriendsMatches = true
    
    switch selectedMedia {
    case .movie:
      await fetchSimpleMovieFriendsMatches()
    case .tvSeries:
      await fetchSimpleTvSeriesFriendsMatches()
    }

    isLoadingSimpleFriendsMatches = false
  }
  
  @MainActor
  func onSubmitQuery() {
    if query != currentQuery {
      currentFriendsPage = 1
      results?.removeAll()
      
      currentQuery = query
      
      Task {
        await fetchSimpleFriendsMatches()
      }
    }
  }
  
  @MainActor
  private func fetchSimpleMovieFriendsMatches() async {
    let result = await repository.getUserMovieMatchesGroupedByFriends(containing: currentQuery, at: currentFriendsPage)

    switch result {
    case .success(let matches):
      self.results.appendItems(matches.results)
      self.maxFriendsPages = matches.totalPages
    case .failure(let error):
      print(error)
    }
  }
  
  @MainActor
  private func fetchSimpleTvSeriesFriendsMatches() async {
    let result = await repository.getUserTvSeriesMatchesGroupedByFriends(containing: currentQuery, at: currentFriendsPage)

    switch result {
    case .success(let matches):
      self.results.appendItems(matches.results)
      self.maxFriendsPages = matches.totalPages
    case .failure(let error):
      print(error)
    }
  }
  
  @MainActor
  func fetchMoreSimpleFriendMatches() async {
    if !isLoadingSimpleFriendsMatches && currentFriendsPage < maxFriendsPages {
      currentFriendsPage += 1
      await fetchSimpleFriendsMatches()
    }
  }
  
  @MainActor
  func changeInterestStatus(for item: any DiscoverItem, from oldStatus: InterestStatus, as newStatus: InterestStatus) {
    guard oldStatus != newStatus else { return }
    
    Task {
      await repository.markMediaAsVisited(for: item, as: newStatus)
    }
  }

  @MainActor
  func onRefresh() async {
    results = nil
    currentFriendsPage = 1
    maxFriendsPages = 1
    currentQuery = ""
    query = ""

    await fetchSimpleFriendsMatches()
  }
}
