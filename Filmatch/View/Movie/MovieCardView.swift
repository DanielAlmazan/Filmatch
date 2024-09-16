//
//  MovieCardView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/8/24.
//

import SwiftUI

struct MovieCardView: View {
  let acceptBound = 100.0
  let declineBound = -100.0

  let movie: DiscoverMoviesItem?

  @State private var offset = CGSize.zero
  @State private var tint = Color.white
  @State var rotation: Angle
  var onAccept: ((DiscoverMoviesItem) -> Void)?
  var onDecline: ((DiscoverMoviesItem) -> Void)?

  var body: some View {
    if let movie = movie {
      ZStack(alignment: .bottom) {
        PosterView(imageUrl: movie.posterPath, size: "w500")
          .clipShape(.rect(cornerRadius: 20))

        Text(movie.title)
          .font(.title3)
          .padding()
          .background(.white.opacity(0.5))
          .clipShape(.rect(cornerRadii: .init(topLeading: 10, topTrailing: 10)))
          .frame(maxWidth: 200)
          .lineLimit(1)
      }
      .colorMultiply(tint)
      .shadow(radius: 5)
      .rotationEffect(rotation)
      .offset(x: offset.width * 1.5)
      .accessibilityAddTraits(.isButton)
      .gesture(
        DragGesture()
          .onChanged { gesture in
            // Moving, rotating and tinting the card based on the gesture
            offset = gesture.translation
            rotation = .degrees(offset.width / 8.0)
            tint = changeColor(width: offset.width)
          }
          .onEnded { _ in
            // TODO: Fix deleting process
            withAnimation {
              /*
               This throws the card away from the view (to the left if declined and to the right
               if accepted. It also will remove the movie from the vm.movies
               */
              if offset.width > acceptBound {
                offset.width = 350
                rotation = .degrees(offset.width / 8.0)
                onAccept?(movie)
              } else if offset.width < declineBound {
                // Lo mismo que arriba, pero en caso de decline
                offset.width = -350
                rotation = .degrees(offset.width / 8.0)
                onDecline?(movie)
              }
            } completion: {
              /*
               This will make the card to come back, which is not the best way, because it is too
               abrupt:
                - It swipes out
                - It is removed
                - Suddenly, the 2nd card becomes the 1st one, which is outside the view
                - Finally, the 2nd (now 1st) card comes back
               
               It is slow and confusing
               */
              offset = .zero
              rotation = .zero
              tint = .white
            }
          }
      )
      .animation(.snappy, value: offset)
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

#Preview{
  MovieCardView(movie: .default, rotation: .zero)
}
