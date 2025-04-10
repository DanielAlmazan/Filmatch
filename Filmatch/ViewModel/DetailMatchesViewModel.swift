//
//  DetailMatchesViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 20/3/25.
//

import Foundation

@Observable
final class DetailMatchesViewModel {
  let repository: OtterMatchGoRepository

  let friend: OtterMatchUser

  var query: String = ""
  private var currentQuery: String = ""

  var mediaType: MediaType
  var matches: [Match]?

  private var currentMoviePage: Int = 1
  private var maxMoviePages: Int = 1

  private var currentTvSeriesPage: Int = 1
  private var maxTvSeriesPages: Int = 1

  var currentPage: Int {
    get {
      switch mediaType {
      case .movie: currentMoviePage
      case .tvSeries: currentTvSeriesPage
      }
    }
    set {
      switch mediaType {
      case .movie: currentMoviePage = newValue
      case .tvSeries: currentTvSeriesPage = newValue
      }
    }
  }

  var maxPages: Int {
    get {
      switch mediaType {
      case .movie: maxMoviePages
      case .tvSeries: maxTvSeriesPages
      }
    }
    set {
      switch mediaType {
      case .movie: maxMoviePages = newValue
      case .tvSeries: maxTvSeriesPages = newValue
      }
    }
  }

  var isLoading: Bool = false

  init(repository: OtterMatchGoRepository, mediaType: MediaType, simpleFriendMatch: SimpleFriendMatch) {
    self.repository = repository
    self.mediaType = mediaType
    self.friend = simpleFriendMatch.user
    self.matches = simpleFriendMatch.matches
  }

  @MainActor
  func fetchMatches() async {
    isLoading = true

    switch mediaType {
    case .movie:
      await fetchMovieMatches()
    case .tvSeries:
      await fetchTvSeriesMatches()
    }

    isLoading = false
  }

  @MainActor
  private func fetchMovieMatches() async {
    let result = await repository.getMovieMatchesByFriendUid(by: friend.uid, containing: currentQuery, at: 1)

    switch result {
    case .success(let response):
      matches.appendItems(response.results)
      maxPages = response.totalPages
    case .failure(let error):
      print(error)
    }
  }

  @MainActor
  private func fetchTvSeriesMatches() async {
    let result = await repository.getTvSeriesMatchesByFriendUid(by: friend.uid, containing: currentQuery, at: 1)

    switch result {
    case .success(let response):
      matches.appendItems(response.results)
      maxPages = response.totalPages
    case .failure(let error):
      print(error)
    }
  }

  @MainActor
  func fetchMoreMatches() async {
    currentPage += 1
    await fetchMatches()
  }

  @MainActor
  func onSearchSubmit() {
    print("Search query submitted")
    if query != currentQuery {
      print("Performing new search query: \(query)")
      self.currentQuery = query
      currentPage = 1
      matches = nil

      Task {
        await fetchMatches()
      }
    }
  }

  @MainActor
  func onRefresh() async {
    currentPage = 1
    matches = nil
    
    await fetchMatches()
  }
}
