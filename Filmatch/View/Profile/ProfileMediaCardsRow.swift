//
//  ProfileMediaCardsRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/2/25.
//

import SwiftUI

struct ProfileMediaCardsRow: View {
  let items: [any DiscoverItem]

  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(items, id: \.id) { item in
          VStack(alignment: .leading) {
            PosterView(
              imageUrl: item.posterPath, size: "w500", posterType: .movie
            )
            .clipShape(.rect(cornerRadius: 10))
          }
          .lineLimit(1)
        }
      }
    }
    .scrollClipDisabled()
  }
}

#Preview {
  ProfileMediaCardsRow(items: [DiscoverMovieItem.default])
}
