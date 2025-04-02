//
//  CardView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/8/24.
//

import SwiftUI

struct CardView: View {
  let item: (any DiscoverItem)?

  var body: some View {
    if let item {
      PosterView(imageUrl: item.posterPath, size: .w500, posterType: .movie)
        .clipShape(.rect(cornerRadius: 20))
        .overlay(alignment: .bottom) {
          Text(
            item.mediaType == .movie
            ? (item as! DiscoverMovieItem).title
            : (item as! DiscoverTvSeriesItem).name
          )
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
  CardView(item: DiscoverMovieItem.default)
}
