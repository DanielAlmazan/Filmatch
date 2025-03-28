//
//  FiltersViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 10/12/24.
//

import Foundation

@Observable
final class FiltersViewModel {
  let filtersRepository: FiltersRepository

  var movieGenres: [Genre] = []
  var areMovieGenresLoading: Bool = false
  var tvGenres: [Genre] = []
  var areTvGenresLoading: Bool = false

  var genres: [Genre] {
    switch self.selectedMedia {
    case .movie: movieGenres
    case .tvSeries: tvGenres
    }
  }

  var movieProviders: [FiltersStreamingProviderSingleResponse] = []
  var areMovieProvidersLoading: Bool = false
  var tvProviders: [FiltersStreamingProviderSingleResponse] = []
  var areTvProvidersLoading: Bool = false

  var providers: [FiltersStreamingProviderSingleResponse] {
    switch self.selectedMedia {
    case .movie: movieProviders
    case .tvSeries: tvProviders
    }
  }

  var currentSelectedMedia: MediaType = .movie
  var selectedMedia: MediaType = .movie

  var filtersDidChange: Bool {
    self.currentSelectedMedia != self.selectedMedia
      || self.currentTvFilters != self.tvFilters
      || self.currentMovieFilters != self.movieFilters
  }

  var movieFilters: MediaFilters = MediaFilters(for: .movie)
  var currentMovieFilters: MediaFilters = MediaFilters(for: .movie)
  var tvFilters: MediaFilters = MediaFilters(for: .tvSeries)
  var currentTvFilters: MediaFilters = MediaFilters(for: .tvSeries)

  var selectedFilters: MediaFilters {
    get {
      switch selectedMedia {
      case .movie: movieFilters
      case .tvSeries: tvFilters
      }
    }
    set {
      switch selectedMedia {
      case .movie: movieFilters = newValue
      case .tvSeries: tvFilters = newValue
      }
    }
  }

  var currentFilters: MediaFilters {
    get {
      switch selectedMedia {
      case .movie: currentMovieFilters
      case .tvSeries: currentTvFilters
      }
    }
    set {
      switch selectedMedia {
      case .movie: currentMovieFilters = newValue
      case .tvSeries: currentTvFilters = newValue
      }
    }
  }

  var errorMessage: String?

  var isMediaMovie: Bool { selectedMedia == .movie }

  init(filtersRepository: FiltersRepository) {
    self.filtersRepository = filtersRepository
  }

  @MainActor
  func fetchFilters() {
    fetchMovieGenres()
    fetchTvGenres()
    fetchMovieProviders()
    fetchTvProviders()
  }

  @MainActor
  func fetchMovieGenres() {
    areMovieGenresLoading = true
    Task {
      let movieGenresResult = await filtersRepository.getGenres(for: .movie)
      switch movieGenresResult {
      case .success(let result): movieGenres = result
      case .failure(let error): print("Error getting movie genres: \(error)")
      }
    }
    areMovieGenresLoading = false
  }

  @MainActor
  func fetchTvGenres() {
    areTvGenresLoading = true
    Task {
      let tvGenresResult = await filtersRepository.getGenres(for: .tvSeries)
      switch tvGenresResult {
      case .success(let result): tvGenres = result
      case .failure(let error): print("Error getting movie genres: \(error)")
      }
    }
    areTvGenresLoading = false
  }

  @MainActor
  func fetchMovieProviders() {
    areMovieProvidersLoading = true
    Task {
      let providersResult = await filtersRepository.getProviders(for: .movie)
      switch providersResult {
      case .success(let result):
        self.movieProviders = result.sortByDisplayPriority()

      case .failure(let error):
        print("Error getting movie providers: \(error)")
      }
    }
    areMovieProvidersLoading = false
  }

  @MainActor
  func fetchTvProviders() {
    areTvProvidersLoading = true
    Task {
      let providersResult = await filtersRepository.getProviders(for: .tvSeries)
      switch providersResult {
      case .success(let result):
        self.tvProviders = result.sortByDisplayPriority()

      case .failure(let error):
        print("Error getting movie providers: \(error)")
      }
    }
    areTvProvidersLoading = false
  }

//  func buildQueryParams(page: Int?) -> [URLQueryItem] {
//    currentFilters.getQueryParams(page: page)
//  }

  func isGenreSelected(_ genre: Genre) -> Bool {
    self.selectedFilters.genres.contains(genre)
  }

  func isProviderSelected(_ provider: FiltersStreamingProviderSingleResponse)
    -> Bool
  {
    self.selectedFilters.providers.contains(provider)
  }

  func areAllProvidersSelected() -> Bool {
    !self.providers.isEmpty
      && self.selectedFilters.providers.count == self.providers.count
  }

  func onGenreSelectionChanged(_ genre: Genre) {
    if let index = self.selectedFilters.genres.firstIndex(of: genre) {
      self.selectedFilters.genres.remove(at: index)
    } else {
      self.selectedFilters.genres.append(genre)
    }
  }

  func toggleAllProviders() {
    selectedFilters.providers = areAllProvidersSelected() ? [] : self.providers
  }

  func onProvidersSelectionChanged(
    _ provider: FiltersStreamingProviderSingleResponse
  ) {
    if let index = self.selectedFilters.providers.firstIndex(of: provider) {
      self.selectedFilters.providers.remove(at: index)
    } else {
      self.selectedFilters.providers.append(provider)
    }
  }

  func toggleMySet() {
    // TODO: Implement user persistence and get its providers.
  }

  func rearrangeFilters() {
    switch selectedMedia {
    case .movie:
      currentSelectedMedia = .movie
      currentMovieFilters = movieFilters
      tvFilters = currentTvFilters
    case .tvSeries:
      currentSelectedMedia = .tvSeries
      currentTvFilters = tvFilters
      movieFilters = currentMovieFilters
    }
  }

  func onCancelButtonTapped() {
    movieFilters = currentMovieFilters
    tvFilters = currentTvFilters
  }
}
