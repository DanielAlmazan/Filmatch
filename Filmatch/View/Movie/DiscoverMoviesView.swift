//
//  DiscoverMoviesView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import CoreHaptics
import SwiftUI

struct DiscoverMoviesView: View {
  enum CardStatus {
    case ACCEPTED, DECLINED, WATCHED, PENDING
  }

  private let maxCardsStack: Int = 3
  private let initialSecondCardBlur: Double = 1.5
  private let initialThirdCardBlur: Double = 3
  private let acceptBound: Double = 150

  private var vm: DiscoverMoviesViewModel

  private var firstCardStatus: CardStatus {
    let accept = (acceptBound...).contains(firstCardOffset.width)
    let declined = (...(-acceptBound)).contains(firstCardOffset.width)
    let watched = (acceptBound...).contains(firstCardOffset.height)

    if accept && !watched {
      return .ACCEPTED
    }

    if declined && !watched {
      return .DECLINED
    }

    if watched && !accept && !declined {
      return .WATCHED
    }

    return .PENDING
  }

  private var tint: Color {
    switch firstCardStatus {
    case .ACCEPTED: .green
    case .DECLINED: .red
    case .WATCHED: .gray
    default: .white
    }
  }

  @State private var isPresented: Bool = false

  @State private var screenWidth: CGFloat

  @State private var firstMovie: DiscoverMoviesItem?
  @State private var firstCardOffset: CGSize = .zero
  private var firstCardRotation: Angle {
    .degrees(firstCardOffset.width / 30)
  }

  @State private var secondMovie: DiscoverMoviesItem?
  @State private var secondCardBlurRadius: Double = 1.5
  @State private var secondCardRotation: Angle = .degrees(-2)

  @State private var thirdMovie: DiscoverMoviesItem?
  @State private var thirdCardBlurRadius: Double = 3
  @State private var thirdCardRotation: Angle = .degrees(2)

  @State private var engine: CHHapticEngine?

  init(repository: MoviesRepository) {
    self.vm = DiscoverMoviesViewModel(repository: repository)
    self.screenWidth = .zero
  }

  var body: some View {
    if self.vm.isLoading {
      ProgressView("Loading...")
    } else if let moviesList = self.vm.movies {
      GeometryReader { geometry in
        Color.clear
          .onAppear {
            self.screenWidth = geometry.size.width
          }
      }
      .frame(height: 0)
      NavigationStack {
        // MARK: Cards Stack
        ZStack {

          // MARK: Third Movie
          if let thirdMovie {
            MovieCardView(movie: thirdMovie)
              .rotationEffect(thirdCardRotation)
              .id(thirdMovie.id)
              .blur(radius: thirdCardBlurRadius)
              .onAppear {
                withAnimation {
                  thirdCardRotation = randomRotation(
                    isEven: self.vm.movies!.count % 2 != 0)
                }
              }
          }

          // MARK: Second Movie
          if let secondMovie {
            MovieCardView(movie: secondMovie)
              .rotationEffect(secondCardRotation)
              .id(secondMovie.id)
              .blur(radius: secondCardBlurRadius)
              .onAppear {
                withAnimation {
                  secondCardRotation = randomRotation(
                    isEven: self.vm.movies!.count % 2 == 0)
                }
              }
          }

          // MARK: First Movie
          if let firstMovie {
            MovieCardView(movie: firstMovie)
              .offset(firstCardOffset)
              .id(firstMovie.id)
              .rotationEffect(firstCardRotation)
              .colorMultiply(tint)
              .onTapGesture {
                isPresented = true
              }
              .sheet(isPresented: $isPresented) {
                MovieDetailView(
                  repository: self.vm.repository, filmId: firstMovie.id)
              }
              .gesture(
                DragGesture()
                  .onChanged { gesture in
                    let multiplier = 1.35
                    let offset = gesture.translation

                    withAnimation {
                      firstCardOffset = .init(
                        width: offset.width * multiplier,
                        height: offset.height * multiplier)
                    }
                  }
                  .onEnded { _ in
                    let extraWidth: Double = 70

                    switch firstCardStatus {
                    case .ACCEPTED:
                      acceptMovie(
                        movie: firstMovie,
                        screenWidth: screenWidth + extraWidth)
                    case .DECLINED:
                      declineMovie(
                        movie: firstMovie,
                        screenWidth: screenWidth + extraWidth)
                    case .WATCHED:
                      return
                    case .PENDING:
                      withAnimation(.bouncy) {
                        firstCardOffset = .zero
                      }
                    }
                  }
              )
              .onAppear(perform: prepareHaptics)
              .onChange(of: firstCardStatus) { _, newStatus in
                triggerHapticFeedback(for: newStatus)
                // We need to fix the haptic feedback for the first card, as
                // if we go to another app or if we block the screen, the haptic
                // feedback stops working.
              }
              .onReceive(
                NotificationCenter.default.publisher(
                  for: UIApplication.didBecomeActiveNotification)
              ) { _ in
                self.restartHapticEngine()
              }
          }
        }
        .padding()
        .navigationTitle("Discover Movies")
        .onAppear {
          self.vm.discoverMovies()
        }
        .onChange(of: moviesList) { _, newList in
          if newList.isEmpty { return }

          self.firstMovie = newList.count >= 1 ? newList.first : nil
          self.secondMovie = newList.count >= 2 ? newList[1] : nil
          self.thirdMovie = newList.count >= 3 ? newList[2] : nil

          // Reset properties for the next card
          firstCardOffset = .zero

          withAnimation {
            self.thirdCardRotation = self.randomRotation(
              isEven: newList.count % 2 == 0)
          }

          // Fetch more movies if necessary
          if newList.count == self.maxCardsStack {
            self.vm.fetchNextPage()
          }
        }

        // MARK: Buttons
        if let movie = moviesList.first {
          AcceptDeclineRowButtons(
            movie: movie, screenWidth: screenWidth, onAccept: acceptMovie,
            onDecline: declineMovie)
        }
      }
    } else {
      Text("\(self.vm.errorMessage ?? "Unexpected error")")
    }
  }

  private func prepareHaptics() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      return
    }

    do {
      engine = try CHHapticEngine()
      try engine?.start()
    } catch {
      print("Error initializing haptic engine: \(error.localizedDescription)")
    }
  }

  private func restartHapticEngine() {
    do {
      try engine?.start()
    } catch {
      print("Error restarting haptic engine: \(error.localizedDescription)")
    }
  }

  private func triggerHapticFeedback(for status: CardStatus) {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
      return
    }

    let intensity: CHHapticEventParameter
    let sharpness: CHHapticEventParameter
    var times: Int = 1

    print("Status: \(status)")

    switch status {
    case .ACCEPTED:
      intensity = CHHapticEventParameter(
        parameterID: .hapticIntensity, value: 0.6)
      sharpness = CHHapticEventParameter(
        parameterID: .hapticSharpness, value: 0.6)
      times = 2
    case .DECLINED:
      intensity = CHHapticEventParameter(
        parameterID: .hapticIntensity, value: 0.4)
      sharpness = CHHapticEventParameter(
        parameterID: .hapticSharpness, value: 0.4)
    case .WATCHED:
      intensity = CHHapticEventParameter(
        parameterID: .hapticIntensity, value: 0.3)
      sharpness = CHHapticEventParameter(
        parameterID: .hapticSharpness, value: 0.3)
    case .PENDING:
      return
    }

    let hapticEvent = CHHapticEvent(
      eventType: .hapticTransient, parameters: [intensity, sharpness],
      relativeTime: 0)

    do {
      let pattern = try CHHapticPattern(events: [hapticEvent], parameters: [])
      let player = try engine?.makePlayer(with: pattern)
      for _ in 0...times {
        try player?.start(atTime: 0)
      }
    } catch {
      print("Error playing haptic feedback: \(error.localizedDescription)")
    }
  }

  private func randomRotation(isEven: Bool) -> Angle {
    let randomValue = Double.random(in: 1.5...3.5)

    return .degrees(isEven ? randomValue : randomValue * -1)
  }

  private func acceptMovie(movie: DiscoverMoviesItem, screenWidth: CGFloat) {
    print("Movie \(movie.title) accepted")

    // TODO: Call to server for notifying this user wants to watch this movie
    removeCard(moveTo: screenWidth)
  }

  private func declineMovie(movie: DiscoverMoviesItem, screenWidth: CGFloat) {
    print("Movie \(movie.title) declined")

    removeCard(moveTo: -screenWidth)
  }

  /// Handles the process of the first card removal.
  ///
  /// - Parameters:
  ///  - offset: The offset to be moved. It is used for modifying the offset but also for rotating the card.
  private func removeCard(moveTo offset: Double) {
    guard let movies = vm.movies, !movies.isEmpty else { return }

    let animationDuration = 0.3

    withAnimation(.easeInOut(duration: animationDuration)) {
      // Move the first card away from the view
      firstCardOffset.width = offset

      // Set the second card's rotation and blur to zero
      secondCardRotation = .zero
      secondCardBlurRadius = .zero
    } completion: {
      secondCardRotation = self.thirdCardRotation
      secondCardBlurRadius = self.initialSecondCardBlur

      // Remove the first movie and card from the lists
      self.vm.movies?.removeFirst()
    }
  }
}

#Preview {
  DiscoverMoviesView(repository: TMDBRepository(remoteDatasource: JsonMoviesRemoteDatasource()))
  //  DiscoverMoviesView(repository: TMDBRepository())
}
