//
//  PosterView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import Kingfisher
import SwiftUI

struct PosterView: View {
  let imageUrl: String
  let size: String

  var body: some View {
    KFImage(URL(string: "https://media.themoviedb.org/t/p/\(size)/\(imageUrl)"))
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
