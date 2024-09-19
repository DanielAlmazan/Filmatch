//
//  DiscoverFilmsView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import SwiftUI

struct DiscoverMoviesView: View {
  private let maxCardsStack: Int = 3
  private let initialSecondCardBlur: Double = 1.5
  private let initialThirdCardBlur: Double = 3
  private let acceptBound: Double = 150
  private let declineBound: Double = -150

  @State private var vm: DiscoverMoviesViewModel

  @State private var screenWidth: CGFloat?

  @State private var firstMovie: DiscoverMoviesItem?
  @State private var firstCardOffset: CGSize = .zero
  @State private var firstCardRotation: Angle = .zero
  @State private var tint: Color = .white

  @State private var secondMovie: DiscoverMoviesItem?
  @State private var secondCardBlurRadius: Double = 1.5
  @State private var secondCardRotation: Angle = .degrees(-2)

  @State private var thirdMovie: DiscoverMoviesItem?
  @State private var thirdCardBlurRadius: Double = 3
  @State private var thirdCardRotation: Angle = .degrees(2)

  init(repository: Repository) {
    self.vm = DiscoverMoviesViewModel(repository: repository)
  }

  var body: some View {
    if self.vm.isLoading {
      ProgressView("Loading...")
    } else if let moviesList = self.vm.movies {
      // MARK: Cards Stack
      GeometryReader { geometry in
        ZStack {
          if thirdMovie != nil {
            MovieCardView(movie: $thirdMovie)
              .rotationEffect(thirdCardRotation)
              .blur(radius: thirdCardBlurRadius)
              .onAppear {
                withAnimation {
                  thirdCardRotation = randomRotation(
                    isEven: self.vm.movies!.count % 2 != 0)
                }
              }
          }

          if secondMovie != nil {
            MovieCardView(movie: $secondMovie)
              .rotationEffect(secondCardRotation)
              .blur(radius: secondCardBlurRadius)
              .onAppear {
                secondCardRotation = randomRotation(
                  isEven: self.vm.movies!.count % 2 == 0)
              }
          }

          if firstMovie != nil {
            MovieCardView(movie: $firstMovie)
              .offset(firstCardOffset)
              .rotationEffect(firstCardRotation)
              .colorMultiply(tint)
              .gesture(
                DragGesture()
                  .onChanged { gesture in
                    let offsetWidth = gesture.translation.width / 0.45

                    withAnimation {
                      firstCardOffset = .init(width: offsetWidth, height: .zero)
                      firstCardRotation = .degrees(offsetWidth / 25)
                      tint = changeColor(width: offsetWidth)
                    }
                  }
                  .onEnded { _ in
                    let extraWidth: Double = 70

                    if firstCardOffset.width > acceptBound {
                      // Movie accepted
                      acceptMovie(
                        movie: firstMovie!,
                        screenWidth: geometry.size.width + extraWidth)
                    } else if firstCardOffset.width < declineBound {
                      // Movie declined
                      declineMovie(
                        movie: firstMovie!,
                        screenWidth: geometry.size.width + extraWidth)
                    } else {
                      // Nothing happened, reset firstCard's modifiers
                      withAnimation(.bouncy) {
                        firstCardOffset = .zero
                        firstCardRotation = .zero
                      }
                    }
                  }
              )
          }
        }
        .padding()
        .onAppear {
          self.screenWidth = geometry.size.width
          self.vm.discoverMovies()
        }
        .onChange(of: moviesList) { _, newList in
          if newList.isEmpty { return }

          self.firstMovie = newList.count >= 1 ? newList.first : nil
          self.secondMovie = newList.count >= 2 ? newList[1] : nil
          self.thirdMovie = newList.count >= 3 ? newList[2] : nil

          // Fetch more movies if necessary
          if newList.count == self.maxCardsStack {
            self.vm.fetchNextPage()
          }
        }
      }

      // MARK: Buttons
      if let movie = moviesList.first {
        AcceptDeclineRowButtons(
          movie: movie, screenWidth: screenWidth ?? 480, onAccept: acceptMovie,
          onDecline: declineMovie)
      }
    } else {
      Text("\(self.vm.errorMessage ?? "Unexpected error")")
    }
  }

  func randomRotation(isEven: Bool) -> Angle {
    let randomValue = Double.random(in: 1.5...3.5)

    return .degrees(isEven ? randomValue : randomValue * -1)
  }

  func acceptMovie(movie: DiscoverMoviesItem, screenWidth: CGFloat) {
    print("Movie \(movie.title) accepted")

    // TODO: Call to server for notifying this user wants to watch this movie
    removeCard(moveTo: screenWidth)
  }

  func declineMovie(movie: DiscoverMoviesItem, screenWidth: CGFloat) {
    print("Movie \(movie.title) declined")

    removeCard(moveTo: -screenWidth)
  }

  /// Handles the process of the first card removal.
  ///
  /// If the movies list is greater than 3, it will create a newThirdCard before deleting the first one.
  /// That newThirdMovie will be appended to the stack. Then, either the first movie and the first card
  /// will be deleted from each list.
  ///
  /// If the movies list equals 3, it will fetch the next page from the repository.
  ///
  /// - Parameters:
  ///  - offset: The offset to be moved. It is used for modifying the offset but also for rotating the card.
  func removeCard(moveTo offset: Double) {
    guard let movies = vm.movies, !movies.isEmpty else { return }

    let animationDuration = 0.6

    withAnimation(.easeInOut(duration: animationDuration)) {
      // Move the first card away from the view
      firstCardOffset.width = offset
      firstCardRotation = .degrees(offset / 30)

      // Set the second card's rotation and blur to zero
      secondCardRotation = .zero
      secondCardBlurRadius = .zero

      // Reset tint to white
      tint = .white
    } completion: {
      secondCardRotation = self.thirdCardRotation
      secondCardBlurRadius = self.initialSecondCardBlur

      if movies.count > 1 {
        firstMovie = secondMovie
      }

      if movies.count > 2 {
        secondMovie = thirdMovie
        thirdCardRotation = .degrees(offset / 50)
        thirdCardBlurRadius = self.initialThirdCardBlur
      }

      // Remove the first movie and card from the lists
      self.vm.movies?.removeFirst()

      // Reset properties for the next card
      firstCardOffset = .zero
      firstCardRotation = .zero

      self.thirdCardRotation = self.randomRotation(
        isEven: movies.count % 2 == 0)
    }
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
