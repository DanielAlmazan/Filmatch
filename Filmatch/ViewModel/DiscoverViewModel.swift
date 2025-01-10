//
//  DiscoverViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

/// `DiscoverViewModel` is responsible for managing the state and data flow for the Discover Movies view.
/// It interacts with the `MoviesRepository` to fetch movies, handles pagination, loading state, and error messages.
@Observable
final class DiscoverViewModel {
  /// The repository used to fetch movie data.
  let moviesRepository: MoviesRepository
  /// The repository used to fetch tv series data.
  let tvSeriesRepository: TvSeriesRepository

  /// The current page number for pagination.
  var currentPage: Int = 1

  var pageParam: URLQueryItem {
    .init(name: QueryParam.page.rawValue, value: String(currentPage))
  }

  /// An array of discovered movies.
//  var movies: [DiscoverMoviesItemSingleResponse]? = []
  var items: [(any DiscoverItem)?]? = []

  /// Indicates whether a loading operation is in progress.
  var isLoading: Bool = false

  /// An optional error message if an error occurs during data fetching.
  var errorMessage: String?

  // TODO: Add filters

  /// Initializes a new instance of `DiscoverMoviesViewModel`.
  /// - Parameter repository: The `MoviesRepository` used to fetch movie data.
  init(moviesRepository: MoviesRepository, tvSeriesRepository: TvSeriesRepository) {
    self.moviesRepository = moviesRepository
    self.tvSeriesRepository = tvSeriesRepository
  }

  /// Fetches movies from the repository based on the current page and updates the `movies` array.
  @MainActor func discoverItems(for media: MediaType, with queryParams: [URLQueryItem]) {
    self.errorMessage = nil
    self.isLoading = true
    Task {
      if media == .movie {
        await discoverMovies(with: queryParams)
      } else if media == .tvSeries {
        await discoverTvSeries(with: queryParams)
      }
    }
    self.isLoading = false
  }
  
  func discoverMovies(with queryParams: [URLQueryItem]) async {
    print("fetching movies on discoverItems on view model")
    let result = await moviesRepository.discoverMovies(withQueryParams: queryParams)
    switch result {
    case .success(let items):
      self.items?.append(contentsOf: items.map { $0.toDiscoverMovieItem() })
      self.currentPage += 1
      print(items)
    case .failure(let error):
      self.errorMessage = error.localizedDescription
      print(error)
    }
  }
  
  func discoverTvSeries(with queryParams: [URLQueryItem]) async {
    print("fetching tv series on discoverItems on view model")
    let result = await tvSeriesRepository.discoverTvSeries(withQueryParams: queryParams)
    switch result {
    case .success(let items):
      self.items?.append(contentsOf: items.map { $0.toDiscoverTvSeriesItem() })
      self.currentPage += 1
      print(items)
    case .failure(let error):
      self.errorMessage = error.localizedDescription
      print(error)
    }
  }

  func resetItems() {
    self.items = []
    self.currentPage = 1
  }
}
