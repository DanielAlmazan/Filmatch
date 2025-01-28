//
//  SearchItemThumbnail.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 20/1/25.
//

import Kingfisher
import SwiftUI

struct SearchItemThumbnail: View {
  /// The relative path to the image file.
  let imageUrl: String?
  /// The desired size of the image. This corresponds to the size parameter in the URL.
  let size: String
  let title: String
  let releaseDate: String?

  @State private var didFail: Bool = false

  init(imageUrl: String?, size: String, title: String, releaseDate: String?) {
    self.imageUrl = imageUrl
    self.size = size
    self.title = title
    self.releaseDate = releaseDate
  }

  var url: URL? {
    URL(string: "\(AppConstants.tmdbMediaBase)/\(size)/\(imageUrl ?? "")")
  }

  var body: some View {
    VStack {
      Group {
        if didFail || imageUrl == nil {
          Image(systemName: "film")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(2 / 3, contentMode: .fit)
          
        } else {
          KFImage.url(url)
            .placeholder {
              ProgressView("Loading...")
            }
            .onFailure { error in
              print(error)
              didFail = true
            }
            .retry(maxCount: 3, interval: .seconds(5))
            .resizable()
            .aspectRatio(2 / 3, contentMode: .fit)
        }
      }
      .clipShape(.rect(cornerRadius: 8))

      VStack(spacing: 5) {
        Text(title)
        
        if let releaseDate {
          Text("(\(releaseDate))")
        }
      }
      .lineLimit(1)
      .padding(8)
    }
    .font(.caption)
    .foregroundColor(.secondary)
  }
}

#Preview {
  SearchItemThumbnail(
    imageUrl: DiscoverMovieItem.default.posterPath, size: "w500",
    title: DiscoverMovieItem.default.title,
    releaseDate: "2024"
  )
  .frame(width: 200)
}
