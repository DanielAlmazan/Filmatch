//
//  MovieDetailViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

/// `MovieDetailViewModel` handles the logic for fetching and storing movie details.
/// It interacts with the `MoviesRepository` to load movie data based on a given movie ID.
@Observable
final class MovieDetailViewModel {
  /// The movie details fetched from the repository.
  var movie: MovieDetailSingleResponse?

  /// Indicates whether the movie is currently being loaded.
  var isMovieLoading: Bool

  /// An optional error message if an error occurs during data fetching.
  var errorMessage: String?

  /// The repository used to fetch movie data.
  private let repository: MoviesRepository

  /// Initializes a new instance of `MovieDetailViewModel`.
  /// - Parameter repository: The `MoviesRepository` used to fetch movie data.
  init(repository: MoviesRepository) {
    self.repository = repository
    self.isMovieLoading = true
  }

  /// Loads the movie details by ID.
  /// - Parameter id: The unique identifier of the movie to load.
  @MainActor
  func loadMovie(byId id: Int) {
    self.errorMessage = nil

    Task {
      let result = await repository.getMovie(byId: id)
      switch result {
        case .success(let movie):
          self.movie = movie
        case .failure(let error):
          self.errorMessage = error.localizedDescription
          print(error)
      }
      self.isMovieLoading = false
    }
  }
}
