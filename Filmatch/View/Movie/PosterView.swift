//
//  PosterView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import SwiftUI

struct PosterView: View {
  let imageUrl: String
  let size: String

  var body: some View {
    AsyncImage(url: URL(string: "https://media.themoviedb.org/t/p/\(size)/\(imageUrl)")) { phase in
      switch phase {
        case .failure:
          Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .padding(40)
        case .success(let image):
          image
            .resizable()
        default:
          ZStack {
            Color.gray
            ProgressView("Loading poster...")
          }
      }
    }
    .frame(maxWidth: .infinity)
    .aspectRatio(2 / 3, contentMode: .fit)
  }
}

#Preview {
  PosterView(
    imageUrl: "1m3W6cpgwuIyjtg5nSnPx7yFkXW.jpg",
    size: "original"
  )
}
