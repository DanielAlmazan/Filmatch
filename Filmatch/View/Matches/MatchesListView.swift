//
//  MatchesListView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 20/3/25.
//

import SwiftUI

struct MatchesListView: View {
  let matches: [Match]
  let onLastAppeared: () -> Void

  @Environment(MoviesRepositoryImpl.self) var moviesRepository
  @Environment(TvSeriesRepositoryImpl.self) var tvRepository
  
  var body: some View {
    LazyVStack(alignment: .leading, spacing: 16) {
      ForEach(matches) { match in
        HStack(spacing: 16) {
          Group {
            NavigationLink {
              if let item = match.item as? DiscoverMovieItem {
                MovieDetailView(repository: moviesRepository, movieId: item.id)
              } else if let item = match.item as? DiscoverTvSeriesItem {
                TvSeriesDetailView(repository: tvRepository, seriesId: item.id)
              }
            } label: {
              MatchView(match: match)
              VStack(alignment: .leading) {
                Text(match.item.getTitle)
                  .font(.headline)
                Text("(\(match.item.getReleaseDate))")
                  .font(.caption)
              }
            }
          }
          .frame(maxHeight: 80)
        }
        .onAppear {
          if match == matches.last {
            onLastAppeared()
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
        originalLanguage: "",
        originalTitle: "Mock 1",
        overview: "Mock",
        popularity: 100,
        posterPath: Match.movieMock.item.posterPath,
        releaseDate: Date(),
        title: "Mock 1",
        video: false,
        voteAverage: 10,
        voteCount: 1),
      status: .superInterested),
    Match(
      isSuperMatch: false,
      item: DiscoverMovieItem(
        adult: false,
        backdropPath: "",
        genreIds: [],
        id: 2,
        originalLanguage: "",
        originalTitle: "Mock 2",
        overview: "Mock",
        popularity: 100,
        posterPath: Match.movieMock.item.posterPath,
        releaseDate: Date(),
        title: "Mock 2",
        video: false,
        voteAverage: 10,
        voteCount: 1),
      status: .superInterested),
  ]
  
  let movieRepository = MoviesRepositoryImpl(datasource: JsonMoviesRemoteDatasource())
  let tvRepository = TvSeriesRepositoryImpl(datasource: JsonTvSeriesDatasource())
  
  NavigationStack {
    VStack {
      MatchesListView(matches: matches) { print("Last appeared") }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding()
    .background(.bgBase)
  }
  .environment(movieRepository)
  .environment(tvRepository)
}
