//
//  SearchItemThumbnail.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 20/1/25.
//

import Kingfisher
import SwiftUI

struct SearchItemThumbnail: View {
  /// The relative path to the image file.
  let imageUrl: String?
  /// The desired size of the image. This corresponds to the size parameter in the URL.
  let size: PosterSize
  let title: String
  let releaseDate: String?
  let status: InterestStatus?

  @State private var didFail: Bool = false

  init(imageUrl: String?, size: PosterSize, title: String, releaseDate: String?, status: InterestStatus?) {
    self.imageUrl = imageUrl
    self.size = size
    self.title = title
    self.releaseDate = releaseDate
    self.status = status
  }

  var url: URL? {
    guard let base = API.tmdbMediaBaseURL, let imageUrl, !imageUrl.isEmpty else {
      return nil
    }
    return URL(string: "\(base)/\(size.rawValue)/\(imageUrl)")
  }

  var body: some View {
    VStack {
      ZStack(alignment: .bottomTrailing) {
        PosterView(imageUrl: imageUrl, size: .w500, posterType: .movie)
          .cornerRadius(10)

        if let icon = status?.icon {
          icon
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 36)
            .offset(x: 10, y: 10)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)

      VStack(spacing: 5) {
        Text(title)
        
        if let releaseDate {
          Text("(\(releaseDate))")
        }
      }
      .lineLimit(1)
      .padding(8)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .font(.caption)
    .foregroundColor(.secondary)
  }
}

#Preview {
  HStack {
    VStack {
      SearchItemThumbnail(
        imageUrl: DiscoverMovieItem.default.posterPath,
        size: .w500,
        title: DiscoverMovieItem.default.title,
        releaseDate: "2024",
        status: .interested
      )
      .frame(maxWidth: 200, maxHeight: 300)

      SearchItemThumbnail(
        imageUrl: DiscoverMovieItem.default.posterPath,
        size: .w500,
        title: DiscoverMovieItem.default.title,
        releaseDate: "2024",
        status: .notInterested
      )
      .frame(maxWidth: 200, maxHeight: 300)

    }

    VStack {
      SearchItemThumbnail(
        imageUrl: DiscoverMovieItem.default.posterPath,
        size: .w500,
        title: DiscoverMovieItem.default.title,
        releaseDate: "2024",
        status: .superInterested
      )
      .frame(maxWidth: 200, maxHeight: 300)

      SearchItemThumbnail(
        imageUrl: DiscoverMovieItem.default.posterPath,
        size: .w500,
        title: DiscoverMovieItem.default.title,
        releaseDate: "2024",
        status: .watched
      )
      .frame(maxWidth: 200, maxHeight: 300)

    }
  }
}
