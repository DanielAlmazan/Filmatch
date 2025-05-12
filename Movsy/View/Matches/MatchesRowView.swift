//
//  MatchesRowView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import SwiftUI

struct MatchesRowView: View {
  let matches: [Match]
  let cornerRadius: CGFloat

  @State private var isPresentingLists: Bool = false

  @Environment(MoviesRepositoryImpl.self) var moviesRepository
  @Environment(TvSeriesRepositoryImpl.self) var tvRepository

  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(matches.prefix(10), id: \.id) { match in
          NavigationLink {
            if let movie = match.item as? DiscoverMovieItem {
              MovieDetailView(repository: moviesRepository, movieId: movie.id)
            } else if let tvSeries = match.item as? DiscoverTvSeriesItem {
              TvSeriesDetailView(repository: tvRepository, seriesId: tvSeries.id)
            }
          } label: {
            VStack(alignment: .leading) {
              MatchView(match: match)
                .onLongPressGesture {
                  // TODO: Apply item list crud
                }
            }
            .lineLimit(1)
          }
        }
      }
    }
    .scrollClipDisabled()
  }
}

#Preview {
  let movieRepository = MoviesRepositoryImpl(datasource: JsonMoviesRemoteDatasource())
  let tvRepository = TvSeriesRepositoryImpl(datasource: JsonTvSeriesDatasource())

  NavigationStack {
    MatchesRowView(matches: [.movieMock], cornerRadius: 10)
      .frame(maxHeight: 150)
      .environment(movieRepository)
      .environment(tvRepository)
  }
}
