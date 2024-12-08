//
//  DiscoverMoviesViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

/// `DiscoverMoviesViewModel` is responsible for managing the state and data flow for the Discover Movies view.
/// It interacts with the `MoviesRepository` to fetch movies, handles pagination, loading state, and error messages.
@Observable
final class DiscoverMoviesViewModel {
  /// The repository used to fetch movie data.
  let repository: MoviesRepository
  
  /// The current page number for pagination.
  var currentPage: Int = 1
  
  /// An array of discovered movies.
  var movies: [DiscoverMoviesItem]? = []
  
  /// Indicates whether a loading operation is in progress.
  var isLoading: Bool
  
  /// An optional error message if an error occurs during data fetching.
  var errorMessage: String?
  
  // TODO: Add filters
  
  /// Initializes a new instance of `DiscoverMoviesViewModel`.
  /// - Parameter repository: The `MoviesRepository` used to fetch movie data.
  init(repository: MoviesRepository) {
    self.repository = repository
    self.isLoading = false
  }
  
  /// Fetches the next page of movies.
  @MainActor func fetchNextPage() {
    self.currentPage += 1
    discoverMovies()
  }

  /// Fetches movies from the repository based on the current page and updates the `movies` array.
  @MainActor func discoverMovies() {
    self.errorMessage = nil
    self.isLoading = true

    Task {
      let result = await repository.discoverMovies(
        withQueryParams: buildQueryParams())
      switch result {
        case .success(let movies):
          self.movies?.append(contentsOf: movies)
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          print(error)
      }
    }
    self.isLoading = false
  }
  
  // TODO: Implement filters
  /// Builds the query parameters for the API request, including pagination and user's providers.
  /// - Returns: An array of `URLQueryItem` for the URLSession.
  func buildQueryParams() -> [URLQueryItem] {
    [
      URLQueryItem(name: "page", value: "\(self.currentPage)"),
      URLQueryItem(
        name: "with_watch_providers",
        value:
          "\(UserModel.default.providers.map{ "\($0.providerId)" }.joined(separator: "|"))"
      ),
    ]
  }
}
