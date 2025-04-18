//
//  MyListViewModel.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 31/3/25.
//

import Foundation

@Observable
final class MyListViewModel {
  let user: MovsyUser?
  let repository: MovsyGoRepository

  let status: InterestStatus
  let media: MediaType

  var items: [any DiscoverItem]?
  private var currentPage: Int = 1
  private var maxPages: Int = 1

  var query: String = ""
  private var currentQuery: String = ""

  private var isLoading: Bool = false

  init(
    user: MovsyUser?,
    repository: MovsyGoRepository,
    status: InterestStatus,
    media: MediaType,
    items: [any DiscoverItem]?
  ) {
    self.user = user
    self.repository = repository
    self.status = status
    self.media = media
    self.items = items
  }

  @MainActor
  func getItems() async {
    guard let user, !isLoading else { return }

    isLoading = true

    switch media {
    case .movie: await getMovies(for: user)
    case .tvSeries: await getTvSeries(for: user)
    }

    isLoading = false
  }

  @MainActor
  private func getMovies(for user: MovsyUser) async {
    let result = await repository.getUserVisitedMoviesByStatus(
      for: user.uid,
      as: status,
      containing: query,
      at: currentPage)

    switch result {
    case .success(let response):
      items.appendItems(response.results.toDiscoverMovieItems(as: status))
      maxPages = response.totalPages
    case .failure(let error):
      print(error)
    }
  }

  @MainActor
  private func getTvSeries(for user: MovsyUser) async {
    let result = await repository.getUserVisitedTvSeriesByStatus(
      for: user.uid,
      as: status,
      containing: query,
      at: currentPage)

    switch result {
    case .success(let response):
      items.appendItems(response.results.toDiscoverTvSeriesItems(as: status))
      maxPages = response.totalPages
    case .failure(let error):
      print(error)
    }
  }

  @MainActor
  func getMoreItems() async {
    guard currentPage <= maxPages else { return }

    currentPage += 1
    await getItems()
  }

  @MainActor
  func onSubmitQuery() async {
    if query != currentQuery {
      currentQuery = query
      currentPage = 1
      maxPages = 1
      items = []
      await getItems()
    }
  }

  @MainActor
  func onRefresh() async {
    currentQuery = ""
    currentPage = 1
    maxPages = 1
    items = []
    await getItems()
  }
}
