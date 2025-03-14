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
  let maxHeight: CGFloat
  let action: () -> Void
  
  private var url: URL? {
    guard let base = API.tmdbMediaBaseURL, let path = item.posterPath, !path.isEmpty else {
      return nil
    }
    return URL(string: "\(base)/w500/\(path)")
  }
  
  var body: some View {
    HStack {
      KFImage.url(url)
      .resizable()
      .clipShape(.rect(cornerRadius: maxHeight/10))
      .scaledToFit()
      .frame(height: maxHeight)
      .aspectRatio(3/2, contentMode: .fit)
      
      VStack {
        Text(item.getTitle)
          .multilineTextAlignment(.leading)

        Text("(\(item.getReleaseDate))")
          .font(.caption)
      }
      .frame(maxHeight: maxHeight)
    }
    .onAppear {
      action()
    }
  }
}

#Preview {
  VStack {
    SimpleMediaItemListRow(item: DiscoverMovieItem.default, maxHeight: 80) {
      print("Pressed")
    }
  }
}
