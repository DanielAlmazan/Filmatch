//
//  MovieCastRowView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 25/8/24.
//

import SwiftUI

/// `MovieCastRowView` displays a horizontal scrollable row of cast members for a movie.
/// It uses `MovieCastMemberView` to display each cast member's information.
struct MovieCastRowView: View {
  /// An optional array of `CastMember` objects representing the movie's cast.
  let cast: [MovieCastMember]?

  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      if let cast = cast {
        HStack(spacing: 16) {
          ForEach(cast.indices, id: \.self) { index in
            MovieCastMemberThumbnailView(castMember: cast[index])
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    MovieCastRowView(cast: [.default, .default, .default, .default])
  }
}
