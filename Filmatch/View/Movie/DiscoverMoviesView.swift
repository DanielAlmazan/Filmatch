//
//  DiscoverFilmsView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import SwiftUI

struct DiscoverMoviesView: View {
  private let maxCardsStack: Int = 3
  private let repository: Repository
  private let initialSecondCardBlur: Double = 1.5
  private let initialThirdCardBlur: Double = 3

  private let acceptBound: Double = 150
  private let declineBound: Double = -150

  @State private var vm: DiscoverMoviesViewModel
  @State private var queryParams: [URLQueryItem]
  @State private var moviesStack: [MovieCardView?] = []
  @State private var firstCardOffset: CGSize = .zero
  @State private var firstCardBlurRadius: Double = 0
  @State private var firstCardRotation: Angle = .zero
  @State private var tint: Color = .white
  @State private var secondCardOffset: CGSize = .zero
  @State private var secondCardBlurRadius: Double = 1.5
  @State private var secondCardRotation: Angle = .degrees(-2)
  @State private var thirdCardOffset: CGSize = .zero
  @State private var thirdCardBlurRadius: Double = 3
  @State private var thirdCardRotation: Angle = .degrees(2)

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
        if vm.moviesStack.count >= 3, let thirdMovieCard = vm.moviesStack[2] {
          thirdMovieCard
            .rotationEffect(thirdCardRotation)
            .blur(radius: thirdCardBlurRadius)
            .onAppear {
              thirdCardRotation = randomRotation(
                isEven: vm.movies!.count % 2 != 0)
            }
        }

        if vm.moviesStack.count >= 2, let secondMovieCard = vm.moviesStack[1] {
          secondMovieCard
            .rotationEffect(secondCardRotation)
            .blur(radius: secondCardBlurRadius)
            .onAppear {
              secondCardRotation = randomRotation(
                isEven: vm.movies!.count % 2 == 0)
            }
        }

        if vm.moviesStack.count >= 1, let firstMovieCard = vm.moviesStack[0] {
          firstMovieCard
            .offset(firstCardOffset)
            .rotationEffect(firstCardRotation)
            .colorMultiply(tint)
            .gesture(
              DragGesture()
                .onChanged { gesture in
                  let offsetWidth = gesture.translation.width / 0.45
                  firstCardOffset = .init(width: offsetWidth, height: .zero)
                  firstCardRotation = .degrees(offsetWidth / 25)

                  withAnimation {
                    tint = changeColor(width: offsetWidth)
                  }
                }
                .onEnded { _ in
                  if firstCardOffset.width > acceptBound {
                    acceptMovie(movie: firstMovieCard.movie!)
                  } else if firstCardOffset.width < declineBound {
                    declineMovie(movie: firstMovieCard.movie!)
                  } else {
                    withAnimation {
                      firstCardOffset = .zero
                      firstCardRotation = .zero
                    }
                  }
                }
            )
//            .animation(.bouncy, value: firstCardOffset)
        }
      }
      .padding()
      .onAppear {
        vm.discoverMovies(
          withQueryParams: buildQueryParams(page: vm.currentPage))
      }

      // MARK: Buttons
      if let movie = moviesList.first {
        AcceptDeclineRowButtons(movie: movie, onAccept: acceptMovie, onDecline: declineMovie)
      }
    } else {
      Text("\(vm.errorMessage ?? "Unexpected error")")
    }
  }

  func randomRotation(isEven: Bool) -> Angle {
    let randomValue = Double.random(in: 1.5...3.5)

    return .degrees(isEven ? randomValue : randomValue * -1)
  }

  @MainActor func acceptMovie(movie: DiscoverMoviesItem) {
    print("Movie \(movie.title) accepted")
    removeCard(moveTo: 450)
  }

  @MainActor func declineMovie(movie: DiscoverMoviesItem) {
    print("Movie \(movie.title) declined")
    removeCard(moveTo: -450)
  }
  
  /// If the movies list is greater than 3, it will create a newThirdCard before deleting the first one.
  /// That newThirdMovie will be appended to the stack. Then, either the first movie and the first card
  /// will be deleted from each list.
  ///
  /// If the movies list equals 3, it will fetch the next page from the repository.
  ///
  @MainActor func removeCard(moveTo offset: Double) {
    withAnimation {
      // Get the first card away from the view
      firstCardOffset.width = offset
      firstCardRotation = .degrees(offset / 50)
      
      // Set the second card's rotation and blur to .zero
      secondCardRotation = .zero
      secondCardBlurRadius = .zero
      
      // Reset tint to white
    } completion: {
      if vm.movies!.count > 3 {
        let newThirdCard: MovieCardView = .init(movie: vm.movies![3])
        vm.moviesStack.append(newThirdCard)
      }
      
      vm.movies?.removeFirst()
      vm.moviesStack.removeFirst()
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        firstCardOffset.width = .zero
        firstCardRotation = .zero
        secondCardRotation = thirdCardRotation
        secondCardBlurRadius = initialSecondCardBlur
        thirdCardRotation = randomRotation(isEven: vm.movies!.count % 2 == 0)
        tint = .white
      }
      
      if vm.movies!.count == maxCardsStack {
        vm.currentPage += 1
        vm.discoverMovies(withQueryParams: buildQueryParams(page: vm.currentPage))
      }
      
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
        value:
          "\(User.default.providers.map{ "\($0.providerId)" }.joined(separator: ","))"
      ),
    ]
  }

  func changeColor(width: CGFloat) -> Color {
    if width > acceptBound {
      return .green
    } else if width < declineBound {
      return .red
    } else {
      return .white
    }
  }
}

#Preview {
  DiscoverMoviesView(repository: JsonPresetRepository())
}
