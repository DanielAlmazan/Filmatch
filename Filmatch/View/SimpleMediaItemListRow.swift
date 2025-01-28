//
//  SimpleMediaItemListRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/1/25.
//

import SwiftUI
import Kingfisher

struct SimpleMediaItemListRow: View {
  let item: any DiscoverItem
  let action: () -> Void
  
  var body: some View {
    HStack {
      KFImage.url(
        URL(
          string:
            "\(AppConstants.tmdbMediaBase)/w500/\(item.posterPath ?? "")"
        )
      )
      .resizable()
      .scaledToFit()
      .frame(maxHeight: 80)
      .clipShape(.rect(cornerRadius: 4))
      
      Text(item.getTitle)
      
      Text("(\(item.getReleaseDate))")
        .font(.caption)
    }
    .onAppear {
      action()
    }

  }
}

#Preview {
  SimpleMediaItemListRow(item: DiscoverMovieItem.default) {
    print("Pressed")
  }
}
