//
//  DiscoverMoviesViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

@Observable
final class DiscoverMoviesViewModel {
  private let thirdCardBlur = 3.0
  private let secondCardBlur = 1.5

  var currentPage: Int = 1
  var movies: [DiscoverMoviesItem]? = []
  var isLoading: Bool
  var errorMessage: String?
  // TODO: Add filters

  private let repository: Repository

  init(repository: Repository) {
    self.repository = repository
    self.isLoading = false
  }
  
  @MainActor func fetchNextPage() {
    self.currentPage += 1
    discoverMovies()
  }

  @MainActor func discoverMovies() {
    self.errorMessage = nil
    self.isLoading = true

    var movies: [DiscoverMoviesItem] = []

    Task {
      do {
        movies = try await repository.discoverMovies(
          withQueryParams: buildQueryParams())
        self.movies?.append(contentsOf: movies)
      } catch {
        self.errorMessage = "Error discovering movies: \(error)"
        print(self.errorMessage!)
      }
    }

    self.isLoading = false
  }
  
  // TODO: Implement filters
  /// Gets the filters info and the user's providers for building the query params
  /// - Returns: An array of URLQueryItem for the URLSession
  func buildQueryParams() -> [URLQueryItem] {
    [
      URLQueryItem(name: "page", value: "\(self.currentPage)"),
      URLQueryItem(
        name: "with_watch_providers",
        value:
          "\(User.default.providers.map{ "\($0.providerId)" }.joined(separator: "|"))"
      ),
    ]
  }
}
