//
//  SimpleMediaItemListView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/1/25.
//

import SwiftUI

struct SimpleMediaItemListView: View {
  @Environment(MoviesRepositoryImpl.self) private var moviesRepository
  @Environment(TvSeriesRepositoryImpl.self) private var tvSeriesRepository
  
  let results: [any DiscoverItem]
  
  let onLastAppeared: () -> Void

  var body: some View {
    ScrollView {
      LazyVStack(alignment: .leading) {
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
            SimpleMediaItemListRow(item: results[index], maxHeight: 80) {
              if index == results.count - 1 {
                onLastAppeared()
              }
            }
          }
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var moviesRepository = MoviesRepositoryImpl(
    datasource: JsonMoviesRemoteDatasource()
//    datasource: MoviesRemoteDatasourceImpl(client: HttpClient())
  )
  @Previewable @State var tvSeriesRepository = TvSeriesRepositoryImpl(
    datasource: JsonTvSeriesDatasource()
//    datasource: TvSeriesDatasourceImpl(client: HttpClient())
  )
  @Previewable @State var personRepository = PersonRepositoryImpl(
    datasource: PersonDatasourceImpl(client: TMDBHttpClient())
  )

  NavigationStack {
    SimpleMediaItemListView(results: [DiscoverMovieItem.default]) {
      print("Last appeared")
    }
  }
  .environment(moviesRepository)
  .environment(tvSeriesRepository)
  .environment(personRepository)
}
