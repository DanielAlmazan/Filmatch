//
//  ProfileViewModel.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 16/2/25.
//

import Foundation

@Observable
final class ProfileViewModel {
  let user: MovsyUser
  let movsyRepository: MovsyGoRepositoryImpl
  let filtersRepository: FiltersRepository

  var selectedMedia: MediaType = .movie
  var query: String?
  private var currentQuery: String?

  var areProvidersLoading: Bool = false
  private var movieProviders: [ProviderModel]?
  private var tvProviders: [ProviderModel]?
  var providers: [ProviderModel]? {
    get {
      switch selectedMedia {
      case .movie: movieProviders
      case .tvSeries: tvProviders
      }
    }
    set {
      switch selectedMedia {
      case .movie: movieProviders = newValue
      case .tvSeries: tvProviders = newValue
      }
    }
  }

  // MARK: - Super Hyped attributes
  private var superHypedMovies: [DiscoverMovieItem]?
  private var superHypedTVSeries: [DiscoverTvSeriesItem]?
  private var superHypedMoviesCurrentPage: Int = 1
  private var superHypedMoviesMaxPages: Int = 1
  private var superHypedTVSeriesCurrentPage: Int = 1
  private var superHypedTVSeriesMaxPages: Int = 1
  private var superHypedCurrentPage: Int {
    get {
      switch selectedMedia {
      case .movie: superHypedMoviesCurrentPage
      case .tvSeries: superHypedTVSeriesCurrentPage
      }
    }
    set {
      switch selectedMedia {
      case .movie: superHypedMoviesCurrentPage = newValue
      case .tvSeries: superHypedTVSeriesCurrentPage = newValue
      }
    }
  }
  private var superHypedMaxPages: Int {
    get {
      switch selectedMedia {
      case .movie: superHypedMoviesMaxPages
      case .tvSeries: superHypedTVSeriesMaxPages
      }
    }
    set {
      switch selectedMedia {
      case .movie: superHypedMoviesMaxPages = newValue
      case .tvSeries: superHypedTVSeriesMaxPages = newValue
      }
    }
  }
  var isSuperHypedLoading: Bool = false
  var superHypedItems: [any DiscoverItem]? {
    get {
      switch selectedMedia {
      case .movie: superHypedMovies
      case .tvSeries: superHypedTVSeries
      }
    }
    set {
      switch selectedMedia {
      case .movie: superHypedMovies = newValue as? [DiscoverMovieItem]
      case .tvSeries: superHypedTVSeries = newValue as? [DiscoverTvSeriesItem]
      }
    }
  }

  // MARK: - Watchlist attributes
  var isWatchlistLoading: Bool = false
  private var watchlistMovies: [DiscoverMovieItem]?
  private var watchlistTVSeries: [DiscoverTvSeriesItem]?
  private var watchlistMoviesCurrentPage: Int = 1
  private var watchlistMoviesMaxPages: Int = 1
  private var watchlistTVSeriesCurrentPage: Int = 1
  private var watchlistTVSeriesMaxPages: Int = 1
  private var watchlistCurrentPage: Int {
    get {
      switch selectedMedia {
      case .movie: watchlistMoviesCurrentPage
      case .tvSeries: watchlistTVSeriesCurrentPage
      }
    }
    set {
      switch selectedMedia {
      case .movie: watchlistMoviesCurrentPage = newValue
      case .tvSeries: watchlistTVSeriesCurrentPage = newValue
      }
    }
  }
  private var watchlistMaxPages: Int {
    get {
      switch selectedMedia {
      case .movie: watchlistMoviesMaxPages
      case .tvSeries: watchlistTVSeriesMaxPages
      }
    }
    set {
      switch selectedMedia {
      case .movie: watchlistMoviesMaxPages = newValue
      case .tvSeries: watchlistTVSeriesMaxPages = newValue
      }
    }
  }
  var watchlistItems: [any DiscoverItem]? {
    get {
      switch selectedMedia {
      case .movie: watchlistMovies
      case .tvSeries: watchlistTVSeries
      }
    }
    set {
      switch selectedMedia {
      case .movie: watchlistMovies = newValue as? [DiscoverMovieItem]
      case .tvSeries: watchlistTVSeries = newValue as? [DiscoverTvSeriesItem]
      }
    }
  }

  // MARK: - Watched attributes
  var isWatchedLoading: Bool = false
  private var watchedMovies: [DiscoverMovieItem]?
  private var watchedTVSeries: [DiscoverTvSeriesItem]?
  private var watchedMoviesCurrentPage: Int = 1
  private var watchedMoviesMaxPages: Int = 1
  private var watchedTVSeriesCurrentPage: Int = 1
  private var watchedTVSeriesMaxPages: Int = 1
  private var watchedCurrentPage: Int {
    get {
      switch selectedMedia {
      case .movie: watchedMoviesCurrentPage
      case .tvSeries: watchedTVSeriesCurrentPage
      }
    }
    set {
      switch selectedMedia {
      case .movie: watchedMoviesCurrentPage = newValue
      case .tvSeries: watchedTVSeriesCurrentPage = newValue
      }
    }
  }
  private var watchedMaxPages: Int {
    get {
      switch selectedMedia {
      case .movie: watchedMoviesMaxPages
      case .tvSeries: watchedTVSeriesMaxPages
      }
    }
    set {
      switch selectedMedia {
      case .movie: watchedMoviesMaxPages = newValue
      case .tvSeries: watchedTVSeriesMaxPages = newValue
      }
    }
  }
  var watchedItems: [any DiscoverItem]? {
    get {
      switch selectedMedia {
      case .movie: watchedMovies
      case .tvSeries: watchedTVSeries
      }
    }
    set {
      switch selectedMedia {
      case .movie: watchedMovies = newValue as? [DiscoverMovieItem]
      case .tvSeries: watchedTVSeries = newValue as? [DiscoverTvSeriesItem]
      }
    }
  }

  // MARK: - Blacklist attributes
  var isBlacklistLoading: Bool = false
  private var blacklistMovies: [DiscoverMovieItem]?
  private var blacklistTVSeries: [DiscoverTvSeriesItem]?
  private var blacklistMoviesCurrentPage: Int = 1
  private var blacklistMoviesMaxPages: Int = 1
  private var blacklistTVSeriesCurrentPage: Int = 1
  private var blacklistTVSeriesMaxPages: Int = 1
  private var blacklistCurrentPage: Int {
    get {
      switch selectedMedia {
      case .movie: blacklistMoviesCurrentPage
      case .tvSeries: blacklistTVSeriesCurrentPage
      }
    }
    set {
      switch selectedMedia {
      case .movie: blacklistMoviesCurrentPage = newValue
      case .tvSeries: blacklistTVSeriesCurrentPage = newValue
      }
    }
  }
  private var blacklistMaxPages: Int {
    get {
      switch selectedMedia {
      case .movie: blacklistMoviesMaxPages
      case .tvSeries: blacklistTVSeriesMaxPages
      }
    }
    set {
      switch selectedMedia {
      case .movie: blacklistMoviesMaxPages = newValue
      case .tvSeries: blacklistTVSeriesMaxPages = newValue
      }
    }
  }
  var blacklistItems: [any DiscoverItem]? {
    get {
      switch selectedMedia {
      case .movie: blacklistMovies
      case .tvSeries: blacklistTVSeries
      }
    }
    set {
      switch selectedMedia {
      case .movie: blacklistMovies = newValue as? [DiscoverMovieItem]
      case .tvSeries: blacklistTVSeries = newValue as? [DiscoverTvSeriesItem]
      }
    }
  }

  // MARK: - Init
  init(
    user: MovsyUser,
    movsyRepository: MovsyGoRepositoryImpl,
    filtersRepository: FiltersRepository
  ) {
    self.user = user
    self.movsyRepository = movsyRepository
    self.filtersRepository = filtersRepository
  }

  // MARK: - Functions

  @MainActor
  func loadProviders() async {
    areProvidersLoading = true

    let movieProvidersResult = await filtersRepository.getProviders(for: selectedMedia)

    switch movieProvidersResult {
    case .success(let response):
      self.providers = response.sortByDisplayPriority().map {
        $0.toProvider()
      }
    case .failure(let error):
      providers = []
      print(error)
    }

    areProvidersLoading = false
  }

  @MainActor
  func loadItems(for status: InterestStatus) async {
    switch status {
    case .watchlist:
      await self.loadLikedItems()
    case .blacklist:
      await self.loadDislikedItems()
    case .watched:
      await loadWatchedItems()
    case .superHype:
      await loadSuperLikedItems()
    case .pending:
      break
    }
  }

  @MainActor
  func loadMoreItems(for status: InterestStatus) async {
    var proceed = true

    switch status {
    case .watchlist:
      if !isWatchlistLoading && watchlistCurrentPage < watchlistMoviesMaxPages {
        self.watchlistCurrentPage += 1
      } else {
        proceed = false
      }
    case .blacklist:
      if !isBlacklistLoading && blacklistCurrentPage <= blacklistMaxPages {
        self.blacklistCurrentPage += 1
      } else {
        proceed = false
      }
    case .watched:
      if !isWatchedLoading && watchedCurrentPage <= watchedMoviesMaxPages {
        self.watchedCurrentPage += 1
      } else {
        proceed = false
      }
    case .superHype:
      if !isSuperHypedLoading && superHypedCurrentPage <= superHypedMaxPages {
        self.blacklistCurrentPage += 1
      } else {
        proceed = false
      }
    case .pending:
      // Not implemented
      proceed = false
      break
    }
    if proceed { await loadItems(for: status) }
  }

  @MainActor
  func updateItem(_ item: any DiscoverItem, for status: InterestStatus) async {
    print("Updating item status")

    updateItemInList(item, for: status)

    let result = await self.movsyRepository.markMediaAsVisited(for: item, as: status)

    switch result {
    case .success:
      print("Updated successfully")
    case .failure(let failure):
      updateItemInList(item, for: item.status)
      print("Error updating: \(failure)")
    }
  }

  private func updateItemInList(_ item: any DiscoverItem, for status: InterestStatus?) {
    print("Updating item in list")

    if let index = watchlistItems?.firstIndex(where: { $0.id == item.id }) {
      watchlistItems![index].status = status
    } else if let index = superHypedItems?.firstIndex(where: { $0.id == item.id }) {
      superHypedItems![index].status = status
    } else if let index = blacklistItems?.firstIndex(where: { $0.id == item.id }) {
      blacklistItems![index].status = status
    } else if let index = watchedItems?.firstIndex(where: { $0.id == item.id }) {
      watchedItems![index].status = status
    }

    print("Updated item in list")
  }

  func onNavigateToDetail(for status: InterestStatus) {
    query = ""
    currentQuery = ""
  }

  @MainActor
  private func loadSuperLikedItems() async {
    isSuperHypedLoading = true

    let result =
      switch selectedMedia {
      case .movie:
        await loadMoviesByStatus(as: .superHype, containing: currentQuery, at: superHypedCurrentPage)
      case .tvSeries:
        await loadTvSeriesByStatus(as: .superHype, containing: currentQuery, at: superHypedCurrentPage)
      }

    superHypedItems.appendItems(result)

    isSuperHypedLoading = false
  }

  @MainActor
  private func loadLikedItems() async {
    isWatchlistLoading = true

    let result =
      switch selectedMedia {
      case .movie:
        await loadMoviesByStatus(as: .watchlist, containing: currentQuery, at: watchlistCurrentPage)
      case .tvSeries:
        await loadTvSeriesByStatus(as: .watchlist, containing: currentQuery, at: watchlistCurrentPage)
      }

    watchlistItems.appendItems(result)

    isWatchlistLoading = false
  }

  @MainActor
  private func loadWatchedItems() async {
    isWatchedLoading = true

    let result =
      switch selectedMedia {
      case .movie:
        await loadMoviesByStatus(as: .watched, containing: currentQuery, at: watchedCurrentPage)
      case .tvSeries:
        await loadTvSeriesByStatus(as: .watched, containing: currentQuery, at: watchedCurrentPage)
      }

    watchedItems.appendItems(result)

    isWatchedLoading = false
  }

  @MainActor
  private func loadDislikedItems() async {
    isBlacklistLoading = true

    let result =
      switch selectedMedia {
      case .movie:
        await loadMoviesByStatus(as: .blacklist, containing: currentQuery, at: blacklistCurrentPage)
      case .tvSeries:
        await loadTvSeriesByStatus(as: .blacklist, containing: currentQuery, at: blacklistCurrentPage)
      }

    blacklistItems.appendItems(result)

    isBlacklistLoading = false
  }

  @MainActor
  private func loadMoviesByStatus(as status: InterestStatus, containing query: String?, at page: Int) async -> [any DiscoverItem] {
    let result = await movsyRepository.getUserVisitedMoviesByStatus(
      for: user.uid,
      as: status,
      at: page)
    switch result {
    case .success(let response):
      setMaxPages(for: status, at: response.totalPages)
      return response.results.toDiscoverMovieItems(as: status)
    case .failure(let error):
      print("Error fetching \(status) Movies: \(error) | \(error.localizedDescription)")
      return []
    }
  }

  @MainActor
  private func loadTvSeriesByStatus(as status: InterestStatus, containing query: String?, at page: Int) async -> [any DiscoverItem] {
    let result = await movsyRepository.getUserVisitedTvSeriesByStatus(
      for: user.uid,
      as: status,
      at: page)
    switch result {
    case .success(let response):
      setMaxPages(for: status, at: page)
      return response.results.toDiscoverTvSeriesItems(as: status)
    case .failure(let error):
      print("Error fetching \(status) TVSeries: \(error)")
      return []
    }
  }

  private func setMaxPages(for status: InterestStatus, at maxPages: Int) {
    switch status {
    case .watchlist:
      self.watchlistMaxPages = maxPages

    case .superHype:
      self.superHypedMaxPages = maxPages

    case .blacklist:
      self.blacklistMaxPages = maxPages

    case .watched:
      self.watchedMaxPages = maxPages

    case .pending:
      break
    }
  }

  func onSelectedMediaChanged() {
    self.query = ""
    self.currentQuery = ""

    self.watchlistMaxPages = 1
    self.watchlistCurrentPage = 1

    self.superHypedMaxPages = 1
    self.superHypedCurrentPage = 1

    self.blacklistMaxPages = 1
    self.blacklistCurrentPage = 1

    self.watchedMaxPages = 1
    self.watchedCurrentPage = 1
  }

  @MainActor
  func onRefresh(of status: InterestStatus) async {
    switch status {
    case .watchlist:
      self.watchlistMaxPages = 1
      self.watchlistCurrentPage = 1
      self.watchlistItems = []
    case .superHype:
      self.superHypedMaxPages = 1
      self.superHypedCurrentPage = 1
      self.superHypedItems = []
    case .blacklist:
      self.blacklistMaxPages = 1
      self.blacklistCurrentPage = 1
      self.blacklistItems = []
    case .watched:
      self.watchedMaxPages = 1
      self.watchedCurrentPage = 1
      self.watchedItems = []
    case .pending:
      break
    }
    await loadItems(for: status)
  }
}
