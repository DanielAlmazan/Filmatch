//
//  SimpleMediaItemListRow.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 23/1/25.
//

import SwiftUI
import Kingfisher

struct SimpleMediaItemListRow: View {
  let item: any DiscoverItem
  let maxHeight: CGFloat
  let onLastAppeared: () -> Void
  
  private var url: URL? {
    guard let base = API.tmdbMediaBaseURL, let path = item.posterPath, !path.isEmpty else {
      return nil
    }
    return URL(string: "\(base)/w500/\(path)")
  }
  
  var body: some View {
    HStack {
      ZStack(alignment: .bottomTrailing) {
        KFImage.url(url)
          .resizable()
          .clipShape(.rect(cornerRadius: maxHeight/10))
          .scaledToFit()
          .frame(height: maxHeight)
          .aspectRatio(3/2, contentMode: .fit)

        if let status = item.status, let icon = status.icon {
          icon
            .resizable()
            .scaledToFit()
            .frame(width: 20)
            .offset(x: 5, y: 5)
        }
      }

      VStack(alignment: .leading) {
        Text(item.getTitle)
          .multilineTextAlignment(.leading)

        Text("(\(item.getReleaseDate))")
          .font(.caption)
      }
      .frame(maxHeight: maxHeight)
    }
//    .containerRelativeFrame(.horizontal, alignment: .leading)
    .onAppear {
      onLastAppeared()
    }
  }
}

#Preview {
  VStack {
    SimpleMediaItemListRow(item: DiscoverMovieItem.default, maxHeight: 80) {
      print("Last appeared")
    }
    SimpleMediaItemListRow(item: DiscoverMovieItem.default, maxHeight: 80) {
      print("Last appeared")
    }
  }
}
