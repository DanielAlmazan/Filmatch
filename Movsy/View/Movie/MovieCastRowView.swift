//
//  MovieCastRowView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 25/8/24.
//

import SwiftUI

/// `MovieCastRowView` displays a horizontal scrollable row of cast members for a movie.
/// It uses `MovieCastMemberView` to display each cast member's information.
struct MovieCastRowView: View {
  /// An optional array of `CastMember` objects representing the movie's cast.
  let cast: [CastMember]?

  var body: some View {
    if let cast = cast, !cast.isEmpty {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 16) {
          ForEach(cast.indices, id: \.self) { index in
            CastMemberThumbnailView(castMember: cast[index])
          }
        }
      }
      .scrollClipDisabled()
    } else {
      VStack {
        Text("No cast members found for this movie.")
      }
    }
  }
}

#Preview("MovieCastRowView Populated") {
  NavigationStack {
    MovieCastRowView(cast: [.default, .default, .default, .default])
  }
  .environment(PersonRepositoryImpl(datasource: JsonPersonRemoteDatasource()))
}

#Preview("MovieCastRowView Empty") {
  NavigationStack {
    MovieCastRowView(cast: [])
  }
  .environment(PersonRepositoryImpl(datasource: JsonPersonRemoteDatasource()))
}
