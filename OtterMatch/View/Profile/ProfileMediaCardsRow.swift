//
//  ProfileMediaCardsRow.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/2/25.
//

import SwiftUI

struct ProfileMediaCardsRow: View {
  let items: [any DiscoverItem]
  let cornerRadius: CGFloat

  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(items, id: \.id) { item in
          VStack(alignment: .leading) {
            PosterView(
              imageUrl: item.posterPath, size: "w500", posterType: .movie
            )
            .clipShape(.rect(cornerRadius: cornerRadius))
          }
          .lineLimit(1)
        }
      }
    }
    .scrollClipDisabled()
  }
}

#Preview {
  HStack {
    ProfileMediaCardsRow(items: [DiscoverMovieItem.default], cornerRadius: 10)
      .frame(height: 200)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
}
