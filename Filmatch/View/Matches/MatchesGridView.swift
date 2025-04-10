//
//  MatchesGridView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import SwiftUI

struct MatchesGridView: View {
  let matches: [Match]
  let onLastAppeared: () -> Void

  @Environment(MoviesRepositoryImpl.self) var moviesRepository
  @Environment(TvSeriesRepositoryImpl.self) var tvRepository

  private let columns = [
    GridItem(.flexible(), spacing: 20),
    GridItem(.flexible(), spacing: 20),
  ]

  var body: some View {
    LazyVGrid(columns: columns, spacing: 20) {
      ForEach(matches) { match in
        NavigationLink {
          if let item = match.item as? DiscoverMovieItem {
            MovieDetailView(repository: moviesRepository, movieId: item.id)
          } else if let item = match.item as? DiscoverTvSeriesItem {
            TvSeriesDetailView(repository: tvRepository, seriesId: item.id)
          }
        } label: {
          MatchView(match: match)
            .onAppear {
              if match == matches.last {
                onLastAppeared()
              }
            }
        }
      }
    }
  }
}

#Preview {
  @Previewable var matches = [
    Match(
      isSuperMatch: true,
      item: DiscoverMovieItem(
        adult: false,
        backdropPath: "",
        genreIds: [],
        id: 1,
        originalLanguage: "Mock",
        originalTitle: "Mock",
        overview: "Mock",
        popularity: 100,
        posterPath: Match.movieMock.item.posterPath,
        releaseDate: Date(),
        title: "Mock",
        video: false,
        voteAverage: 10,
        voteCount: 1
      ),
      status: .superInterested
    ),
    Match(
      isSuperMatch: false,
      item: DiscoverMovieItem(
        adult: false,
        backdropPath: "",
        genreIds: [],
        id: 2,
        originalLanguage: "Mock",
        originalTitle: "Mock",
        overview: "Mock",
        popularity: 100,
        posterPath: Match.movieMock.item.posterPath,
        releaseDate: Date(),
        title: "Mock",
        video: false,
        voteAverage: 10,
        voteCount: 1
      ),
      status: .superInterested
    ),
  ]

  let movieRepository = MoviesRepositoryImpl(datasource: JsonMoviesRemoteDatasource())
  let tvRepository = TvSeriesRepositoryImpl(datasource: JsonTvSeriesDatasource())

  ScrollView {
    MatchesGridView(matches: matches) { print("Last appeared") }
      .padding(.horizontal)
  }
  .scrollClipDisabled()
  .environment(movieRepository)
  .environment(tvRepository)
}
