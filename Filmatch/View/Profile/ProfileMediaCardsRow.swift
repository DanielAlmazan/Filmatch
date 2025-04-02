//
//  ProfileMediaCardsRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/2/25.
//

import SwiftUI

struct ProfileMediaCardsRow: View {
  var items: [any DiscoverItem]
  let cornerRadius: CGFloat

  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(items.prefix(20), id: \.id) { item in
          ZStack(alignment: .bottomTrailing) {
            PosterView(
              imageUrl: item.posterPath, size: .w342, posterType: .movie
            )
            .clipShape(.rect(cornerRadius: cornerRadius))
            if let status = item.status {
              status.icon
                .offset(x: 6, y: 6)
            }
          }
          .lineLimit(1)
        }
      }
    }
    .scrollClipDisabled()
  }
}

#Preview {
  @Previewable @State var movie = DiscoverMovieItem.default

  HStack {
    ProfileMediaCardsRow(items: [movie], cornerRadius: 10)
      .frame(height: 200)
      .task { movie.status = .interested }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
}
