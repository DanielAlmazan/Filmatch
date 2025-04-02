//
//  SimpleMediaItemsGridView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/1/25.
//

import SwiftUI

struct SimpleMediaItemsGridView: View {
  private let columns = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16),
  ]

  @Environment(MoviesRepositoryImpl.self) private var moviesRepository
  @Environment(TvSeriesRepositoryImpl.self) private var tvSeriesRepository

  let results: [any DiscoverItem]

  let onLastAppeared: () -> Void

  var body: some View {
    LazyVGrid(columns: columns, spacing: 16) {
      ForEach(results.indices, id: \.self) { index in
        NavigationLink {
          if let movie = results[index] as? DiscoverMovieItem {
            MovieDetailView(
              repository: moviesRepository,
              movieId: movie.id
            )
          } else if let tv = results[index] as? DiscoverTvSeriesItem {
            TvSeriesDetailView(
              repository: tvSeriesRepository,
              seriesId: tv.id
            )
          } else {
            Text("Unsupported item")
          }
        } label: {
          SearchItemThumbnail(
            imageUrl: results[index].posterPath,
            size: .w342,
            title: results[index].getTitle,
            releaseDate: results[index].getReleaseDate,
            status: results[index].status
          )
          .onAppear {
            if index == results.count - 1 {
              onLastAppeared()
            }
          }
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var movie = DiscoverMovieItem.default

  SimpleMediaItemsGridView(results: [movie]) {
    print("Last appeared")
  }
  .task { movie.status = .interested }
  .environment(
    MoviesRepositoryImpl(
      datasource: JsonMoviesRemoteDatasource()
    )
  )
  .environment(
    TvSeriesRepositoryImpl(
      datasource: JsonTvSeriesDatasource()
    ))
}
