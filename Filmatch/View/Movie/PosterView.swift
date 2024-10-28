//
//  PosterView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import Kingfisher
import SwiftUI

/// `PosterView` is a SwiftUI view that displays a movie poster image.
/// It fetches and displays an image from a given URL, using the Kingfisher library for efficient image loading and caching.
struct PosterView: View {
  /// The relative path to the image file.
  let imageUrl: String
  
  /// The desired size of the image. This corresponds to the size parameter in the URL.
  let size: String
  
  /// The complete URL constructed from the `imageUrl` and `size`.
  var url: URL {
    URL(string: "https://media.themoviedb.org/t/p/\(size)/\(imageUrl)")!
  }

  var body: some View {
    KFImage.url(url)
      .resizable()
      .aspectRatio(2 / 3, contentMode: .fit)
  }
}

#Preview {
  PosterView(
    imageUrl: "1m3W6cpgwuIyjtg5nSnPx7yFkXW.jpg",
    size: "original"
  )
}
