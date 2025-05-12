//
//  SimpleMediaItemsGridView.swift
//  Movsy
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

  @Binding var results: [any DiscoverItem]?

  let updateItem: (any DiscoverItem, InterestStatus?) -> Void
  let onLastAppeared: () -> Void

  var body: some View {
    if results != nil {
      LazyVGrid(columns: columns, spacing: 16) {
        ForEach(results!.indices, id: \.self) { index in
          NavigationLink {
            if let movie = results![index] as? DiscoverMovieItem {
              MovieDetailView(
                repository: moviesRepository,
                movieId: movie.id
              )
            } else if let tv = results![index] as? DiscoverTvSeriesItem {
              TvSeriesDetailView(
                repository: tvSeriesRepository,
                seriesId: tv.id
              )
            } else {
              Text("Unsupported item")
            }
          } label: {
            let statusBinding = Binding<InterestStatus?>(
              get: { results![index].status },
              set: { newStatus in
                guard let index = results!.firstIndex(where: { $0.id == results![index].id }) else { return }
                updateItem(results![index], newStatus)
                results![index].status = newStatus
              }
            )

            ZStack(alignment: .topTrailing) {
              SearchItemThumbnail(
                imageUrl: results![index].posterPath,
                size: .w342,
                title: results![index].getTitle,
                releaseDate: results![index].getReleaseDate,
                status: results![index].status
              )
              .contextMenu {
                InterestStatusPicker(selection: statusBinding)
              }
              .onAppear {
                if index == results!.count - 1 {
                  onLastAppeared()
                }
              }

              Menu {
                InterestStatusPicker(selection: statusBinding)
              } label: {
                Image(systemName: "ellipsis")
                  .shadow(color: .black, radius: 5)
                  .rotationEffect(.degrees(90))
                  .frame(width: 30, height: 30)
                  .foregroundStyle(.white)
              }
            }
          }
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var movies: [any DiscoverItem]? = [DiscoverMovieItem.default]

  SimpleMediaItemsGridView(results: $movies) { _, _ in

  } onLastAppeared: {
    print("Last appeared")
  }
  .task { movies![0].status = .watchlist }
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
