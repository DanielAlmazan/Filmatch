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
      .scaledToFit()
      .frame(height: 80)
      .aspectRatio(3/2, contentMode: .fit)
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
