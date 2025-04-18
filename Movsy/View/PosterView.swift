//
//  PosterView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import Kingfisher
import SwiftUI

/// `PosterView` is a SwiftUI view that displays a movie poster image.
/// It fetches and displays an image from a given URL, using the Kingfisher library for efficient image loading and caching.
struct PosterView: View {
  enum PosterType: String {
    case movie = "film"
    case person
  }

  /// The relative path to the image file.
  let imageUrl: String?

  /// The desired size of the image. This corresponds to the size parameter in the URL.
  let size: PosterSize

  let posterType: PosterType
  
  @State private var didFail: Bool = false

  /// The complete URL constructed from the `imageUrl` and `size`.
  var url: URL? {
    guard let base = API.tmdbMediaBaseURL, let imageUrl, !imageUrl.isEmpty else {
      return nil
    }
    return URL(string: "\(base)/\(size.rawValue)/\(imageUrl)")
  }

  var body: some View {
    if didFail || imageUrl == nil || imageUrl!.isEmpty {
      Image(systemName: posterType.rawValue)
        .resizable()
        .aspectRatio(1, contentMode: .fit)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(2 / 3, contentMode: .fit)
        .background(.onBgBase)

    } else {
      KFImage.url(url)
        .placeholder {
          ProgressView("Loading...")
        }
        .onFailure{ error in
          print(error)
          didFail = true
        }
        .retry(maxCount: 3, interval: .seconds(5))
        .resizable()
        .aspectRatio(2 / 3, contentMode: .fit)
    }
  }
}

#Preview{
  PosterView(
    imageUrl: "1m3W6cpgwuIyjtg5nSnPx7yFkXW.jpg",
    size: .w342,
    posterType: .movie
  )
}
