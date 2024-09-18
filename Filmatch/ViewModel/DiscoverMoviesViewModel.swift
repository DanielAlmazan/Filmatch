//
//  DiscoverMoviesViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation
import SwiftUI

@Observable
final class DiscoverMoviesViewModel {
  private let thirdCardBlur = 3.0
  private let secondCardBlur = 1.5

  var currentPage: Int = 1
  var movies: [DiscoverMoviesItem]?
  var moviesStack: [MovieCardView?] = []
  var isLoading: Bool
  var errorMessage: String?
  // TODO: Add filters

  private let repository: Repository

  init(repository: Repository) {
    self.repository = repository
    self.movies = []
    self.isLoading = false
    self.currentPage = currentPage
  }

  @MainActor func removeMovie() {
    movies?.removeFirst()

    if movies != nil && movies!.count > 3 {

    }
  }

  @MainActor func discoverMovies(withQueryParams queryParams: [URLQueryItem]) {
    self.errorMessage = nil
    self.isLoading = true

    var movies: [DiscoverMoviesItem] = []

    Task {
      do {
        movies = try await repository.discoverMovies(
          withQueryParams: queryParams)
        self.movies?.append(contentsOf: movies)
        self.moviesStack = buildMoviesStack()
      } catch {
        self.errorMessage = "Error discovering movies: \(error)"
        print(self.errorMessage!)
      }
    }

    self.isLoading = false
  }
  
  @MainActor func buildMoviesStack() -> [MovieCardView] {
    [.init(movie: movies?[0]), .init(movie: movies?[1]), .init(movie: movies?[2])]
//      .init(
//        movie: movies?[0] , cardOffset: .zero, cardRotation: .zero,
//        cardBlurRadius: 0),
//      .init(
//        movie: movies?[1] , cardOffset: .zero,
//        cardRotation: .degrees(randomRotation(forIndex: 1)),
//        cardBlurRadius: secondCardBlur),
//      .init(
//        movie: movies?[2] , cardOffset: .zero,
//        cardRotation: .degrees(randomRotation(forIndex: 2)),
//        cardBlurRadius: thirdCardBlur),
//    ]
  }
  
  func randomRotation(forIndex index: Int) -> Double {
    if index == 0 {
      return 0
    }

    let randomValue = Double.random(in: 1.5...3.5)

    return index % 2 == 0 ? randomValue : randomValue * -1
  }
}
