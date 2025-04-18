//
//  SearchViewModel.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 18/1/25.
//

import Foundation

@Observable
final class SearchViewModel {
  private let moviesRepository: MoviesRepository
  private let tvSeriesRepository: TvSeriesRepository
  private let movsyRepository: MovsyGoRepository

  var selectedMedia: MediaType = .movie

  private var movieQuery: String = ""
  private var tvQuery: String = ""

  var query: String {
    get {
      switch selectedMedia {
      case .movie: movieQuery
      case .tvSeries: tvQuery
      }
    }
    set {
      switch selectedMedia {
      case .movie: movieQuery = newValue
      case .tvSeries: tvQuery = newValue
      }
    }
  }

  private var changedQuery: Bool {
    switch selectedMedia {
    case .movie: query != lastSearchMovieQuery
    case .tvSeries: query != lastSearchTvQuery
    }
  }

  private var lastSearchMovieQuery: String = ""
  private var lastSearchTvQuery: String = ""
  private var lastSearchQuery: String {
    get {
      switch selectedMedia {
      case .movie: lastSearchMovieQuery
      case .tvSeries: lastSearchTvQuery
      }
    }
    set {
      switch selectedMedia {
      case .movie: lastSearchMovieQuery = newValue
      case .tvSeries: lastSearchTvQuery = newValue
      }
    }
  }

  private var moviesResults: [any DiscoverItem]? = []
  private var tvSeriesResults: [any DiscoverItem]? = []

  var currentResults: [any DiscoverItem]? {
    get {
      switch selectedMedia {
      case .movie: moviesResults
      case .tvSeries: tvSeriesResults
      }
    }
    set {
      switch selectedMedia {
      case .movie:
        moviesResults = newValue
      case .tvSeries:
        tvSeriesResults = newValue
      }
    }
  }

  private var currentMoviesPage: Int = 1
  private var currentTvPage: Int = 1
  private var currentPage: Int {
    get {
      switch selectedMedia {
      case .movie: currentMoviesPage
      case .tvSeries: currentTvPage
      }
    }
    set {
      switch selectedMedia {
      case .movie: currentMoviesPage = newValue
      case .tvSeries: currentTvPage = newValue
      }
    }
  }

  private var currentMovieMaxPages: Int?
  private var currentTvMaxPages: Int?
  private var currentMaxPages: Int? {
    get {
      switch selectedMedia {
      case .movie: currentMovieMaxPages
      case .tvSeries: currentTvMaxPages
      }
    }
    set {
      switch selectedMedia {
      case .movie: currentMovieMaxPages = newValue
      case .tvSeries: currentTvMaxPages = newValue
      }
    }
  }

  var shouldPerformSearch: Bool {
    !isLoading
      && !query.isEmpty
      && currentResults?.isEmpty ?? true
      || lastSearchQuery != query
      || currentMaxPages != nil
        && currentMaxPages! >= currentPage
  }

  var errorMessage: String?
  var isLoading: Bool = false

  init(
    moviesRepository: MoviesRepository,
    tvSeriesRepository: TvSeriesRepository,
    movsyRepository: MovsyGoRepository
  ) {
    self.moviesRepository = moviesRepository
    self.tvSeriesRepository = tvSeriesRepository
    self.movsyRepository = movsyRepository
  }

  @MainActor
  func search() {
    errorMessage = nil
    isLoading = true

    if changedQuery {
      resetSearchResults()
    }

    if shouldPerformSearch {
      Task {
        switch selectedMedia {
        case .movie: await searchMovies(for: query)
        case .tvSeries: await searchTvShows(for: query)
        }
      }
    }
    isLoading = false
  }

  @MainActor
  private func searchMovies(for query: String) async {
    Task {
      let result = await moviesRepository.searchMovies(
        query, page: currentPage)

      switch result {
      case .success(let movies):
        moviesResults.appendItems(movies.results.map { $0.toDiscoverMovieItem() })
        currentMaxPages = movies.totalPages
        currentPage += 1
        lastSearchMovieQuery = query
      case .failure(let error):
        errorMessage = error.localizedDescription
        print(error)
      }
    }
  }

  @MainActor
  private func searchTvShows(for query: String) async {
    Task {
      let result = await tvSeriesRepository.searchTvSeries(
        query, page: currentPage)

      switch result {
      case .success(let tvSeries):
        tvSeriesResults.appendItems(tvSeries.results.map { $0.toDiscoverTvSeriesItem() })
        currentMaxPages = tvSeries.totalPages
        currentPage += 1
        lastSearchTvQuery = query
      case .failure(let error):
        errorMessage = error.localizedDescription
        print(error)
      }
    }
  }

  @MainActor
  func updateItem(_ item: any DiscoverItem, for status: InterestStatus) async {
    let result = await self.movsyRepository.markMediaAsVisited(for: item, as: status)
    let previousStatus = item.status
    updateItemInList(item, for: status)

    switch result {
    case .success:
      print("Updated successfully")
    case .failure(let failure):
      updateItemInList(item, for: previousStatus)
      print("Error updating: \(failure)")
    }
  }

  private func updateItemInList(_ item: any DiscoverItem, for status: InterestStatus?) {
    guard let safeCurrentResults = currentResults, let index = safeCurrentResults.firstIndex(where: { $0.status == item.status }) else { return }

    currentResults![index].status = status ?? item.status
  }

  private func resetSearchResults() {
    currentPage = 1
    currentResults = []
  }
}
