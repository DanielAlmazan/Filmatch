//
//  MovieCardView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/8/24.
//

import SwiftUI

struct MovieCardView: View {
  let movie: DiscoverMoviesItem?

  var body: some View {
    if let movie = movie {
      PosterView(imageUrl: movie.posterPath, size: "w500")
        .clipShape(.rect(cornerRadius: 20))
        .overlay(alignment: .bottom) {
          Text(movie.title)
          .font(.title3)
          .padding()
          .background(
            .ultraThinMaterial,
            in: .rect(cornerRadii: .init(topLeading: 10, topTrailing: 10))
          )
          .frame(maxWidth: .infinity)
          .lineLimit(1)
          .padding(.horizontal, 20)
        }
        .shadow(radius: 5)
    }
  }
}

#Preview {
  MovieCardView(movie: .default)
}
