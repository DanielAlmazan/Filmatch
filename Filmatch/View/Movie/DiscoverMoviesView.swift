//
//  DiscoverFilmsView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import SwiftUI

struct DiscoverMoviesView: View {
  private let initialSecondObjectValue = -2.5
  private let declineRange: ClosedRange<CGFloat> = -500...(-120)
  private let acceptRange: ClosedRange<CGFloat> = 120...500
  private let repository: Repository

  @State private var discoverMoviesViewModel: DiscoverMoviesViewModel
  @State private var offset: CGSize
  @State private var secondOffset: CGSize
  @State private var tint: Color = .white
  @State private var offsetMultiplier: CGFloat = 1
  @State private var queryParams: [URLQueryItem]

  init(repository: Repository) {
    self.repository = repository
    discoverMoviesViewModel = DiscoverMoviesViewModel(repository: repository)

    offset = .zero
    secondOffset = CGSize(width: initialSecondObjectValue, height: .zero)
    queryParams = [URLQueryItem(name: "page", value: "1")]
  }

  var body: some View {
    if discoverMoviesViewModel.isLoading {
      Text("Loading")
      ProgressView("Loading...")
    } else if let moviesList = discoverMoviesViewModel.movies {
      ZStack {
        // MARK: Third Movie Card
        if moviesList.count >= 3 {
          MovieCardView(posterPath: moviesList[2].posterPath, title: moviesList[1].title)
            .blur(radius: 2.3)
            .offset(y: -20)
            .rotationEffect(Angle(degrees: 2.5))
            .shadow(radius: 10, y: 10)
        }

        // MARK: Second Movie Card
        if moviesList.count >= 2 {
          MovieCardView(posterPath: moviesList[1].posterPath, title: moviesList[1].title)
            .blur(radius: 1.2)
            .offset(x: secondOffset.width, y: secondOffset.height * 0.4 - 10)
            .rotationEffect(.degrees(Double(secondOffset.width / 100)))
            .shadow(radius: 10, y: 10)
        }

        // MARK: First Movie Card
        if let firstMovie = moviesList.first {
          MovieCardView(posterPath: firstMovie.posterPath, title: firstMovie.title)
            .colorMultiply(tint)
            .shadow(radius: 10, y: 10)
            .offset(x: offset.width * offsetMultiplier, y: offset.height * 0.4)
            .rotationEffect(.degrees(Double(offset.width / 10)))
            .gesture(
              DragGesture()
                .onChanged { gesture in  // Interacting with the card
                  withAnimation {
                    // Place the card in the new position
                    offset = gesture.translation

                    // Set the propper offset multiplier
                    offsetMultiplier = incrementOffsetMultiplier(width: offset.width)

                    // Set a tint over the card | NOT WORKING
                    tint = changeColor(width: offset.width)
                  }
                }
                .onEnded { gesture in
                  withAnimation {
                    offset = swipeCard(width: offset.width)

                    if offset.width > acceptRange.upperBound {
                      print("\(firstMovie.title) accepted")

                      secondOffset = swipeCard(width: offset.width)

                      discoverMoviesViewModel.movies!.removeFirst()
                    } else if offset.width < declineRange.lowerBound {
                      print("\(firstMovie.title) declined")

                      secondOffset = swipeCard(width: offset.width)

                      discoverMoviesViewModel.movies!.removeFirst()
                    }

                    secondOffset = swipeCard(width: offset.width)
                    tint = changeColor(width: offset.width)
                    secondOffset.width = 0

                    if discoverMoviesViewModel.movies!.count < 4 {
                      discoverMoviesViewModel.currentPage += 1

                      discoverMoviesViewModel.discoverMovies(
                        withQueryParams: buildQueryParams(page: discoverMoviesViewModel.currentPage)
                      )
                    }

                    secondOffset.width = initialSecondObjectValue

                    offset = CGSizeZero
                  }
                }
            )
        }

      }
      .padding()
      .onAppear {
        discoverMoviesViewModel.discoverMovies(
          withQueryParams: buildQueryParams(page: discoverMoviesViewModel.currentPage))
      }
    } else {
        Text("\(discoverMoviesViewModel.errorMessage ?? "Unexpected error")")
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

  func incrementOffsetMultiplier(width: CGFloat) -> CGFloat {
    switch width {
    case acceptRange, declineRange:
      return 1.5
    default:
      return 1
    }
  }

  /// Used for relocating the card based on the current position
  /// - Parameter width: The position where the card is
  /// - Returns: A new position for the card
  func swipeCard(width: CGFloat) -> CGSize {
    switch width {
    case acceptRange:
      return CGSize(width: 10000, height: 0)

    case declineRange:
      return CGSize(width: -10000, height: 0)

    default:
      return .zero
    }
  }

  func changeColor(width: CGFloat) -> Color {
    switch width {
    case acceptRange:
      return .green

    case declineRange:
      return .red

    default:
      return .white
    }
  }
}

#Preview{
  DiscoverMoviesView(repository: JsonPresetRepository())
}
