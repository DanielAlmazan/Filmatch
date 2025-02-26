//
//  ProfileViewModel.swift
//  OtterMatch
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

  var areSuperLikedLoading: Bool = false
  private var superLikedMovies: [DiscoverMovieItem]?
  private var superLikedTVSeries: [DiscoverTvSeriesItem]?
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
  func loadSuperLikedItems() async {
    areSuperLikedLoading = true
    
    self.superLikedItems = switch selectedMedia {
    case .movie:
      await loadMoviesByStatus(as: .superInterested)
    case .tvSeries:
      await loadTvSeriesByStatus(as: .superInterested)
    }
    
    areSuperLikedLoading = false
  }
  
  @MainActor
  func loadLikedItems() async {
    areLikedLoading = true
    
    self.likedItems = switch selectedMedia {
    case .movie:
      await loadMoviesByStatus(as: .interested)
    case .tvSeries:
      await loadTvSeriesByStatus(as: .interested)
    }
    
    areLikedLoading = false
  }
  
  @MainActor
  func loadWatchedItems() async {
    areWatchedLoading = true
    
    self.watchedItems = switch selectedMedia {
    case .movie:
      await loadMoviesByStatus(as: .interested)
    case .tvSeries:
      await loadTvSeriesByStatus(as: .interested)
    }
    
    areWatchedLoading = false
  }
  
  @MainActor
  func loadDislikedItems() async {
    areDislikedLoading = true
    
    self.dislikedItems = switch selectedMedia {
    case .movie:
      await loadMoviesByStatus(as: .notInterested)
    case .tvSeries:
      await loadTvSeriesByStatus(as: .notInterested)
    }
    
    areDislikedLoading = false
  }
  
  @MainActor
  func loadMoviesByStatus(as status: InterestStatus) async -> [any DiscoverItem] {
    let superLikedMovies = await otterMatchRepository.getUserVisitedMoviesByStatus(
      for: user.uid,
      as: status,
      at: 1)
    switch superLikedMovies {
    case .success(let response):
      return response
    case .failure(let error):
      print("Error fetching \(status) Movies: \(error)")
      return []
    }
  }
  
  @MainActor
  func loadTvSeriesByStatus(as status: InterestStatus) async -> [any DiscoverItem] {
    let superLikedMovies = await otterMatchRepository.getUserVisitedTvSeriesByStatus(
      for: user.uid,
      as: status,
      at: 1)
    switch superLikedMovies {
    case .success(let response):
      return response
    case .failure(let error):
      print("Error fetching \(status) TVSeries: \(error)")
      return []
    }
  }
}
