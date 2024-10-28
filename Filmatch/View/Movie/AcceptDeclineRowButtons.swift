//
//  AcceptDeclineRowButtons.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/9/24.
//

import SwiftUI

struct AcceptDeclineRowButtons: View {
  let movie: DiscoverMoviesItem
  let screenWidth: CGFloat
  let onAccept: (DiscoverMoviesItem, CGFloat) -> Void
  let onDecline: (DiscoverMoviesItem, CGFloat) -> Void
  
  var body: some View {
    HStack {
      Button {
        onDecline(movie, screenWidth)
      } label: {
        Image(.thumbDownButton)
          .resizable()
          .scaledToFit()
          .frame(width: 100)
      }

      Spacer()

      Button {
        onAccept(movie, screenWidth)
      } label: {
        Image(.thumbUpButton)
          .resizable()
          .scaledToFit()
          .frame(width: 100)
      }
    }
    .padding()
  }
}

#Preview {
  AcceptDeclineRowButtons(movie: .default, screenWidth: 480, onAccept: {movie, width  in print ("Accepted \(movie.title)") }, onDecline: { movie, width in print ("Declined \(movie.title)")})
}
