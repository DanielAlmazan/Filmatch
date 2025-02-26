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
  /// The repository used to interact with our own API
  let otterMatchRepository: OtterMatchGoRepository
  
  let kLoadingThreshold: Int = 4

  /// The current page number for pagination.
  var currentPage: Int = 1

  var pageParam: URLQueryItem {
    .init(name: QueryParam.page.rawValue, value: String(currentPage))
  }

  var currentMaxPages: Int = 1

  var shouldDiscoverItems: Bool {
    currentMaxPages >= currentPage
  }

  /// An array of discovered movies.
  var items: [(any DiscoverItem)]?

  /// Indicates whether a loading operation is in progress.
  //  var isLoading: Bool = false

  /// An optional error message if an error occurs during data fetching.
  var errorMessage: String?

  /// Initializes a new instance of `DiscoverMoviesViewModel`.
  init(
    moviesRepository: MoviesRepository,
    tvSeriesRepository: TvSeriesRepository,
    otterMatchRepository: OtterMatchGoRepository
  ) {
    self.moviesRepository = moviesRepository
    self.tvSeriesRepository = tvSeriesRepository
    self.otterMatchRepository = otterMatchRepository
  }

  @MainActor private func getCleanVisitedItems(
    for media: MediaType, from items: [any DiscoverItem]
  ) async -> [any DiscoverItem] {
    let ids = items.map { "\($0.id)" }.joined(separator: ",")

    let result: Result<[Int], Error>

    switch media {
    case .movie: result = await otterMatchRepository.getMovieVisitsByIds(for: ids)
    case .tvSeries: result = await otterMatchRepository.getTvVisitsByIds(for: ids)
    }

    return switch result {
    case .success(let visitedIds): items.filter { !visitedIds.contains($0.id) }
    case .failure(_): items
    }
  }

  /// Fetches Discover Items from the repository based on the current page and updates the `movies` array.
  @MainActor func discoverItems(
    for media: MediaType,
    with filters: MediaFilters
  ) async {
    guard shouldDiscoverItems else { return }

    self.errorMessage = nil
    // Always fetch the first page
    switch media {
    case .movie: await discoverMovies(with: filters)
    case .tvSeries: await discoverTvSeries(with: filters)
    }

    // Removing visited items
    if let items = self.items {
      self.items = await getCleanVisitedItems(for: media, from: items)
    }

    // If user has already visited every item
    if let items = self.items, items.isEmpty {
      // Fetch the first
      if self.currentPage <= 3 {
        await discoverItems(for: media, with: filters)
      } else {
        // The has visited more than 3 pages
        // Getting the latest visited page...
        let latestPageResult = await self.otterMatchRepository
          .getLatestVisitedPageByFiltersHash(for: filters.filtersHash())

        switch latestPageResult {
        case .success(let latestPage):
          // Replace current page if the latest is higher
          if latestPage > currentPage {
            currentPage = latestPage
          } else {
            // Otherwise, update the DB with the current page
            await self.createVisitedFilterHash(for: filters, at: currentPage)
          }
          // Fetch the proper page
          await discoverItems(for: media, with: filters)
        case .failure(let error):
          await self.createVisitedFilterHash(for: filters, at: currentPage)
          print(error)
        }
      }
    } else if let items = self.items, items.count < kLoadingThreshold {
      // If the size of the list is below the loading threshold, let's
      // fetch the next page.
      await discoverItems(for: media, with: filters)
    }
  }

  @MainActor
  func discoverMovies(with filters: MediaFilters) async {
    let result = await moviesRepository.discoverMovies(
      withQueryParams: filters.getQueryParams(
        page: currentPage
      )
    )
    switch result {
    case .success(let response):
      if self.items != nil {
        self.items!.append(
          contentsOf: response.results.map { $0.toDiscoverMovieItem() })
      } else {
        self.items = response.results.map { $0.toDiscoverMovieItem() }
      }
      self.currentMaxPages = response.totalPages
      self.currentPage += 1
    case .failure(let error):
      self.errorMessage = error.localizedDescription
      print("❌ Error fetching Movies: \(error)")
    }
  }

  @MainActor
  func discoverTvSeries(with filters: MediaFilters) async {
    let result = await tvSeriesRepository.discoverTvSeries(
      withQueryParams: filters.getQueryParams(page: currentPage))
    switch result {
    case .success(let response):
      if self.items != nil {
        self.items!.append(
          contentsOf: response.results.map { $0.toDiscoverTvSeriesItem() })
      } else {
        self.items = response.results.map { $0.toDiscoverTvSeriesItem() }
      }
      self.currentMaxPages = response.totalPages
      self.currentPage += 1
    case .failure(let error):
      self.errorMessage = error.localizedDescription
      print("❌ Error fetching Tv Series: \(error)")
    }
  }

  @MainActor
  func createVisitedFilterHash(for filter: MediaFilters, at page: Int = 1)
    async
  {
    let result = await otterMatchRepository.createVisitedFiltersHash(
      for: filter, at: page)

    switch result {
    case .success(_):
      print("✅ Filter hash posted successfully at page \(page)!")
    case .failure(let error):
      print(
        "❌ Error creating visited filters hash: \(error.localizedDescription)")
    }
  }

  func resetItems() {
    self.items = []
    self.currentPage = 1
  }
}
