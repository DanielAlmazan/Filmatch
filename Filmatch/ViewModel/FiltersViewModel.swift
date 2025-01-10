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
  var movieProviders: [StreamingProviderSingleResponse] = []
  var areMovieProvidersLoading: Bool = false
  var tvProviders: [StreamingProviderSingleResponse] = []
  var areTvProvidersLoading: Bool = false
  
  var currentSelectedMedia: MediaType = .movie
  var selectedMedia: MediaType = .movie
  
  var filtersDidChange: Bool {
    self.currentSelectedMedia != self.selectedMedia
    || self.currentTvFilters != self.tvFilters
    || self.currentMovieFilters != self.movieFilters
  }

  var movieFilters: MediaFilters = MediaFilters()
  var currentMovieFilters: MediaFilters = MediaFilters()
  var tvFilters: MediaFilters = MediaFilters()
  var currentTvFilters: MediaFilters = MediaFilters()
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
    Task {
      areMovieGenresLoading = true
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
    Task {
      areTvGenresLoading = true
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
          self.movieProviders = result.sorted { $0.displayPriority ?? 0 < $1.displayPriority ?? 0 }
          
        case .failure(let error):
          print("Error getting movie providers: \(error)")
      }
      areMovieProvidersLoading = false
    }
  }

  @MainActor
  func fetchTvProviders() {
    areTvProvidersLoading = true
    Task {
      let providersResult = await filtersRepository.getProviders(for: .tvSeries)
      switch providersResult {
        case .success(let result):
          self.tvProviders = result.sorted { $0.displayPriority ?? 0 < $1.displayPriority ?? 0 }
          
        case .failure(let error):
          print("Error getting movie providers: \(error)")
      }
    }
    areTvProvidersLoading = false
  }

  func buildQueryParams(page: Int?) -> [URLQueryItem] {
    selectedMedia == .movie ? movieFilters.getQueryParams(page: page) : tvFilters.getQueryParams(page: page)
  }
  
  func isGenreSelected(_ genre: Genre) -> Bool {
    selectedGenres().contains(genre)
  }
  
  func isProviderSelected(_ provider: StreamingProviderSingleResponse?) -> Bool {
    guard let provider else { return false }
    
    return selectedProviders().contains(provider)
  }
  
  func areAllProvidersSelected() -> Bool {
    let selected = selectedProviders()
    let all = self.selectedMedia == .movie ? movieProviders : tvProviders
    
    return !all.isEmpty && selected.count == all.count
  }
  
  /// Returns the array of selected genres for the given media type.
  private func selectedGenres() -> [Genre] {
    self.selectedMedia == .movie ? movieFilters.genres : tvFilters.genres
  }
  
  /// Replaces the array of selected genres for the given media type.
  private func setSelectedGenres(_ list: [Genre]) {
    if self.selectedMedia == .movie {
      movieFilters.genres = list
    } else {
      tvFilters.genres = list
    }
  }
  
  /// Returns the array of selected genres for the given media type.
  func selectedProviders() -> [StreamingProviderSingleResponse] {
    self.selectedMedia == .movie ? movieFilters.providers : tvFilters.providers
  }
  
  /// Replaces the array of selected genres for the given media type.
  private func setSelectedProviders(_ list: [StreamingProviderSingleResponse]) {
    if self.selectedMedia == .movie {
      movieFilters.providers = list
    } else {
      tvFilters.providers = list
    }
  }
  
  func onGenreSelectionChanged(_ genre: Genre) {
    var list = selectedGenres()
    
    if let index = list.firstIndex(of: genre) {
      list.remove(at: index)
      print("Removed genre '\(genre.name ?? "nil")'")
    } else {
      list.append(genre)
      print("Added genre '\(genre.name ?? "nil")'")
    }
    
    setSelectedGenres(list)
    
    print("Current genres: \(list.map{ $0.name ?? "nil"})")
  }
  
  func toggleAllProviders() {
    let all = self.selectedMedia == .movie ? movieProviders : tvProviders
    
    if areAllProvidersSelected() {
      setSelectedProviders([])
      print("All providers deselected")
    } else {
      setSelectedProviders(all)
      print("All providers selected")
    }
  }
  
  func onProvidersSelectionChanged(_ provider: StreamingProviderSingleResponse) {
    var list = selectedProviders()
    
    if let index = list.firstIndex(of: provider) {
      list.remove(at: index)
      print("Removed provider \(provider.providerName ?? "nil")")
    } else {
      list.append(provider)
      print("Added provider \(provider.providerName ?? "nil")")
    }
    
    setSelectedProviders(list)
    
    print(selectedProviders().map{ $0.providerName ?? "nil" })
  }
  
  func toggleMySet() {
    // TODO: Implement user persistance and get its providers.
  }
  
  func rearrangeFilters() {
    if isMediaMovie {
      currentSelectedMedia = .movie
      currentMovieFilters = movieFilters
      tvFilters = currentTvFilters
    } else {
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
