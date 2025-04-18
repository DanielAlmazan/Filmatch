//
//  PersonMovieCreditsAsCastRow.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 14/1/25.
//

import SwiftUI

struct PersonMovieCreditsAsCastRow: View {
  let movies: [PersonMovieCreditsAsCastMember]
  let width: CGFloat

  @Environment(MoviesRepositoryImpl.self) var moviesRepository

  var body: some View {
    if movies.isEmpty {
      Text("No movies found")
        .frame(maxWidth: .infinity, alignment: .center)
    } else {
      VStack(alignment: .leading, spacing: 8) {
        Text("As cast member...")
          .font(.headline)

        ScrollView(.horizontal) {
          LazyHGrid(rows: [GridItem()]) {
            ForEach(movies) { movie in
              if let movieId = movie.id {
                NavigationLink(destination: MovieDetailView(repository: moviesRepository, movieId: movieId)) {
                  VStack(alignment: .leading) {
                    PosterView(imageUrl: movie.posterPath, size: .w500, posterType: .movie)
                      .clipShape(.rect(cornerRadius: 10))
                    if let title = movie.title {
                      Text("In \"\(title)\"")
                        .font(.headline)
                    }
                    if let character = movie.character {
                      Text("As \(character)")
                        .font(.caption)
                    }
                  }
                  .lineLimit(1)
                }
                .frame(width: width)
              }
            }
          }
        }
      }
    }
  }
}

#Preview {
  PersonMovieCreditsAsCastRow(movies: [], width: 100)
    .environment(MoviesRepositoryImpl(
      datasource: JsonMoviesRemoteDatasource()
    ))
}
