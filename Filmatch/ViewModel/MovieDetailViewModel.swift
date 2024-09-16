//
//  DetailViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

@Observable
final class MovieDetailViewModel {
  var movie: MovieDetailSingleResponse?
  var isMovieLoading: Bool
  var errorMessage: String?

  private let repository: Repository

  init(repository: Repository) {
    self.repository = repository
    self.isMovieLoading = true
  }

  @MainActor
  func loadMovie(byId id: Int) {
    self.errorMessage = nil

    Task {
      do {
        self.movie = try await repository.getMovie(byId: id)
      } catch {
        self.errorMessage = "Failed to load movie with ID \"\(id)\"\n\(error.localizedDescription)"
      }
    }

    self.isMovieLoading = false
  }
}
