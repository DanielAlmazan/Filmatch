//
//  DiscoverFilmsView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import SwiftUI

struct DiscoverMoviesView: View {
  private let maxCardsStack = 3
  private let repository: Repository

  @State private var vm: DiscoverMoviesViewModel
  @State private var queryParams: [URLQueryItem]

  init(repository: Repository) {
    self.repository = repository
    vm = DiscoverMoviesViewModel(repository: repository)

    queryParams = [URLQueryItem(name: "page", value: "1")]
  }

  var body: some View {
    if vm.isLoading {
      ProgressView("Loading...")
    } else if let moviesList = vm.movies {
      // MARK: Cards Stack
      ZStack {
        ForEach((0..<min(moviesList.count, maxCardsStack)).reversed(), id: \.self) { index in
          MovieCardView(
            movie: moviesList[index],
            rotation: .degrees(randomRotation(forIndex: index)),
            onAccept: acceptMovie,
            onDecline: declineMovie
          )
          .blur(radius: CGFloat(index))
          .allowsHitTesting(index == 0)
        }
      }
      .padding()
      .onAppear {
        vm.discoverMovies(withQueryParams: buildQueryParams(page: vm.currentPage))
      }

      // MARK: Buttons
      HStack {
        if let movie = moviesList.first {
          Button {
            declineMovie(movie: movie)
          } label: {
            Image(systemName: "xmark.circle.fill")
              .resizable()
              .foregroundStyle(.red)
              .scaledToFit()
              .frame(width: 100)
          }

          Spacer()

          Button {
            acceptMovie(movie: movie)
          } label: {
            Image(systemName: "checkmark.circle.fill")
              .resizable()
              .foregroundStyle(.green)
              .scaledToFit()
              .frame(width: 100)
          }
        }
      }
      .padding()
    } else {
      Text("\(vm.errorMessage ?? "Unexpected error")")
    }
  }

  func randomRotation(forIndex index: Int) -> Double {
    if index == 0 {
      return 0
    }

    let randomValue = Double.random(in: 1.5...3.5)

    return index % 2 == 0 ? randomValue : randomValue * -1
  }
  
  @MainActor func acceptMovie(movie: DiscoverMoviesItem) {
    print("Movie with \(movie.title) accepted")
    removeCard()
  }

  @MainActor func declineMovie(movie: DiscoverMoviesItem) {
    print("Movie with \(movie.title) declined")
    removeCard()
  }

  @MainActor func removeCard() {
    vm.movies?.removeFirst()

    if vm.movies!.count == maxCardsStack {
      vm.currentPage += 1
      vm.discoverMovies(withQueryParams: buildQueryParams(page: vm.currentPage))
    }
  }

  // TODO: Implement filters
  /// Gets the filters info and the user's providers for building the query params
  /// - Returns: An array of URLQueryItem for the URLSession
  func buildQueryParams(page: Int) -> [URLQueryItem] {
    [
      URLQueryItem(name: "page", value: "\(page)"),
      URLQueryItem(
        name: "with_watch_providers",
        value: "\(User.default.providers.map{ "\($0.providerId)" }.joined(separator: " "))"),
    ]
  }
}

#Preview{
  DiscoverMoviesView(repository: JsonPresetRepository())
}
