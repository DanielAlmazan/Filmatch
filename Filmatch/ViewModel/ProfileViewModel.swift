//
//  ProfileViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 16/2/25.
//

import Foundation

@Observable
final class ProfileViewModel {
  let user: OtterMatchUser
  let otterMatchRepository: OtterMatchGoRepositoryImpl
  let filtersRepository: FiltersRepository

  var selectedMedia: MediaType = .movie

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

  private var superLikedMovies: [DiscoverMovieItem]?
  private var superLikedTVSeries: [DiscoverTvSeriesItem]?
  private var superLikedMoviesCurrentPage: Int = 1
  private var superLikedMoviesMaxPages: Int = 1
  private var superLikedTVSeriesCurrentPage: Int = 1
  private var superLikedTVSeriesMaxPages: Int = 1
  private var superLikedCurrentPage: Int {
    get {
      switch selectedMedia {
      case .movie: superLikedMoviesCurrentPage
      case .tvSeries: superLikedTVSeriesCurrentPage
      }
    }
    set {
      switch selectedMedia {
      case .movie: superLikedMoviesCurrentPage = newValue
      case .tvSeries: superLikedTVSeriesCurrentPage = newValue
      }
    }
  }
  private var superLikedMaxPages: Int {
    get {
      switch selectedMedia {
      case .movie: superLikedMoviesMaxPages
      case .tvSeries: superLikedTVSeriesMaxPages
      }
    }
    set {
      switch selectedMedia {
      case .movie: superLikedMoviesMaxPages = newValue
      case .tvSeries: superLikedTVSeriesMaxPages = newValue
      }
    }
  }
  var areSuperLikedLoading: Bool = false
  var superLikedItems: [any DiscoverItem]? {
    get {
      switch selectedMedia {
      case .movie: superLikedMovies
      case .tvSeries: superLikedTVSeries
      }
    }
    set {
      switch selectedMedia {
      case .movie: superLikedMovies = newValue as? [DiscoverMovieItem]
      case .tvSeries: superLikedTVSeries = newValue as? [DiscoverTvSeriesItem]
      }
    }
  }

  var areLikedLoading: Bool = false
  private var likedMovies: [DiscoverMovieItem]?
  private var likedTVSeries: [DiscoverTvSeriesItem]?
  private var likedMoviesCurrentPage: Int = 1
  private var likedMoviesMaxPages: Int = 1
  private var likedTVSeriesCurrentPage: Int = 1
  private var likedTVSeriesMaxPages: Int = 1
  private var likedCurrentPage: Int {
    get {
      switch selectedMedia {
      case .movie: likedMoviesCurrentPage
      case .tvSeries: likedTVSeriesCurrentPage
      }
    }
    set {
      switch selectedMedia {
      case .movie: likedMoviesCurrentPage = newValue
      case .tvSeries: likedTVSeriesCurrentPage = newValue
      }
    }
  }
  private var likedMaxPages: Int {
    get {
      switch selectedMedia {
      case .movie: likedMoviesMaxPages
      case .tvSeries: likedTVSeriesMaxPages
      }
    }
    set {
      switch selectedMedia {
      case .movie: likedMoviesMaxPages = newValue
      case .tvSeries: likedTVSeriesMaxPages = newValue
      }
    }
  }
  var likedItems: [any DiscoverItem]? {
    get {
      switch selectedMedia {
      case .movie: likedMovies
      case .tvSeries: likedTVSeries
      }
    }
    set {
      switch selectedMedia {
      case .movie: likedMovies = newValue as? [DiscoverMovieItem]
      case .tvSeries: likedTVSeries = newValue as? [DiscoverTvSeriesItem]
      }
    }
  }

  var areWatchedLoading: Bool = false
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

  var areDislikedLoading: Bool = false
  private var dislikedMovies: [DiscoverMovieItem]?
  private var dislikedTVSeries: [DiscoverTvSeriesItem]?
  private var dislikedMoviesCurrentPage: Int = 1
  private var dislikedMoviesMaxPages: Int = 1
  private var dislikedTVSeriesCurrentPage: Int = 1
  private var dislikedTVSeriesMaxPages: Int = 1
  private var dislikedCurrentPage: Int {
    get {
      switch selectedMedia {
      case .movie: dislikedMoviesCurrentPage
      case .tvSeries: dislikedTVSeriesCurrentPage
      }
    }
    set {
      switch selectedMedia {
      case .movie: dislikedMoviesCurrentPage = newValue
      case .tvSeries: dislikedTVSeriesCurrentPage = newValue
      }
    }
  }
  private var dislikedMaxPages: Int {
    get {
      switch selectedMedia {
      case .movie: dislikedMoviesMaxPages
      case .tvSeries: dislikedTVSeriesMaxPages
      }
    }
    set {
      switch selectedMedia {
      case .movie: dislikedMoviesMaxPages = newValue
      case .tvSeries: dislikedTVSeriesMaxPages = newValue
      }
    }
  }
  var dislikedItems: [any DiscoverItem]? {
    get {
      switch selectedMedia {
      case .movie: dislikedMovies
      case .tvSeries: dislikedTVSeries
      }
    }
    set {
      switch selectedMedia {
      case .movie: dislikedMovies = newValue as? [DiscoverMovieItem]
      case .tvSeries: dislikedTVSeries = newValue as? [DiscoverTvSeriesItem]
      }
    }
  }
  
  init(
    user: OtterMatchUser,
    otterMatchRepository: OtterMatchGoRepositoryImpl,
    filtersRepository: FiltersRepository
  ) {
    self.user = user
    self.otterMatchRepository = otterMatchRepository
    self.filtersRepository = filtersRepository
  }
  
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
    case .interested:
      await self.loadLikedItems()
    case .notInterested:
      await self.loadDislikedItems()
    case .watched:
      await loadWatchedItems()
    case .superInterested:
      await loadSuperLikedItems()
    case .pending:
      break
    }
  }
  
  @MainActor
  func loadMoreItems(for status: InterestStatus) async {
    var proceed = true

    switch status {
    case .interested:
      if !areLikedLoading && likedCurrentPage < likedMoviesMaxPages {
        self.likedCurrentPage += 1
      } else {
        proceed = false
      }
    case .notInterested:
      print("areDislikedLoading: \(areDislikedLoading) - currentPage: \(dislikedCurrentPage) - maxPages: \(dislikedMaxPages)")
      print("the condition: \(!areDislikedLoading && dislikedCurrentPage <= dislikedMaxPages)")
      if !areDislikedLoading && dislikedCurrentPage <= dislikedMaxPages {
        self.dislikedCurrentPage += 1
      } else {
        proceed = false
      }
    case .watched:
      if !areWatchedLoading && watchedCurrentPage <= watchedMoviesMaxPages {
        self.watchedCurrentPage += 1
      } else {
        proceed = false
      }
    case .superInterested:
      if !areSuperLikedLoading && superLikedCurrentPage <= superLikedMaxPages {
        self.dislikedCurrentPage += 1
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
  private func loadSuperLikedItems() async {
    areSuperLikedLoading = true
    
    self.superLikedItems = switch selectedMedia {
    case .movie:
      await loadMoviesByStatus(as: .superInterested, at: superLikedCurrentPage)
    case .tvSeries:
      await loadTvSeriesByStatus(as: .superInterested, at: superLikedCurrentPage)
    }
    
    areSuperLikedLoading = false
  }
  
  @MainActor
  private func loadLikedItems() async {
    areLikedLoading = true
    
    self.likedItems = switch selectedMedia {
    case .movie:
      await loadMoviesByStatus(as: .interested, at: likedCurrentPage)
    case .tvSeries:
      await loadTvSeriesByStatus(as: .interested, at: likedCurrentPage)
    }
    
    areLikedLoading = false
  }
  
  @MainActor
  private func loadWatchedItems() async {
    areWatchedLoading = true
    
    self.watchedItems = switch selectedMedia {
    case .movie:
      await loadMoviesByStatus(as: .interested, at: watchedCurrentPage)
    case .tvSeries:
      await loadTvSeriesByStatus(as: .interested, at: watchedCurrentPage)
    }
    
    areWatchedLoading = false
  }
  
  @MainActor
  private func loadDislikedItems() async {
    areDislikedLoading = true
    
    let result = switch selectedMedia {
    case .movie:
      await loadMoviesByStatus(as: .notInterested, at: dislikedCurrentPage)
    case .tvSeries:
      await loadTvSeriesByStatus(as: .notInterested, at: dislikedCurrentPage)
    }
    
    dislikedItems.appendItems(result)
    
    areDislikedLoading = false
  }
  
  @MainActor
  private func loadMoviesByStatus(as status: InterestStatus, at page: Int) async -> [any DiscoverItem] {
    let superLikedMovies = await otterMatchRepository.getUserVisitedMoviesByStatus(
      for: user.uid,
      as: status,
      at: page)
    switch superLikedMovies {
    case .success(let response):
      setMaxPages(for: status, at: response.totalPages)
      return response.results.toDiscoverMovieItems()
    case .failure(let error):
      print("Error fetching \(status) Movies: \(error)")
      return []
    }
  }
  
  @MainActor
  private func loadTvSeriesByStatus(as status: InterestStatus, at page: Int) async -> [any DiscoverItem] {
    let superLikedMovies = await otterMatchRepository.getUserVisitedTvSeriesByStatus(
      for: user.uid,
      as: status,
      at: page)
    switch superLikedMovies {
    case .success(let response):
      setMaxPages(for: status, at: page)
      return response.results.toDiscoverTvSeriesItems()
    case .failure(let error):
      print("Error fetching \(status) TVSeries: \(error)")
      return []
    }
  }
  
  private func setMaxPages(for status: InterestStatus, at maxPages: Int) {
    switch status {
    case .interested:
      self.likedMaxPages = maxPages

    case .superInterested:
      self.superLikedMaxPages = maxPages

    case .notInterested:
      self.dislikedMaxPages = maxPages

    case .watched:
      self.watchedMaxPages = maxPages

    case .pending:
      break
    }
  }
}
