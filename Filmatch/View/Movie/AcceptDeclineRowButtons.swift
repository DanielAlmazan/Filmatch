//
//  AcceptDeclineRowButtons.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/9/24.
//

import SwiftUI

struct AcceptDeclineRowButtons: View {
  let movie: DiscoverMoviesItem
  let onAccept: (DiscoverMoviesItem) -> Void
  let onDecline: (DiscoverMoviesItem) -> Void
  
  var body: some View {
    HStack {
      Button {
        onDecline(movie)
      } label: {
        Image(systemName: "xmark.circle.fill")
          .resizable()
          .foregroundStyle(.red)
          .scaledToFit()
          .frame(width: 100)
      }

      Spacer()

      Button {
        onAccept(movie)
      } label: {
        Image(systemName: "checkmark.circle.fill")
          .resizable()
          .foregroundStyle(.green)
          .scaledToFit()
          .frame(width: 100)
      }
    }
    .padding()
  }
}

#Preview {
  AcceptDeclineRowButtons(movie: .default, onAccept: {movie in print ("Accepted \(movie.title)") }, onDecline: { movie in print ("Declined \(movie.title)")})
}
