//
//  SimpleMediaItemListView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 23/1/25.
//

import SwiftUI

struct SimpleMediaItemListView: View {
  @Environment(MoviesRepositoryImpl.self) private var moviesRepository
  @Environment(TvSeriesRepositoryImpl.self) private var tvSeriesRepository

  @Binding var results: [any DiscoverItem]?

  let updateItem: (any DiscoverItem, InterestStatus?) -> Void
  let onLastAppeared: () -> Void

  var body: some View {
    if results != nil {
      LazyVStack(alignment: .leading) {
        ForEach(results!, id: \.id) { item in
          let statusBinding = Binding<InterestStatus?>(
            get: { item.status },
            set: { newStatus in
              guard let index = results!.firstIndex(where: { $0.id == item.id }) else { return }
              results![index].status = newStatus
              updateItem(item, newStatus)
            }
          )
          NavigationLink {
            if let movie = item as? DiscoverMovieItem {
              MovieDetailView(
                repository: moviesRepository,
                movieId: movie.id
              )
            } else if let tv = item as? DiscoverTvSeriesItem {
              TvSeriesDetailView(
                repository: tvSeriesRepository,
                seriesId: tv.id
              )
            } else {
              Text("Unsupported item")
            }
          } label: {
            HStack {
              SimpleMediaItemListRow(item: item, maxHeight: 80) {
                if let lastItem = results!.last, item.id == lastItem.id {
                  onLastAppeared()
                }
              }

              Spacer()

              Menu {
                InterestStatusPicker(selection: statusBinding)
              } label: {
                Image(systemName: "ellipsis")
                  .rotationEffect(.degrees(90))
                  .padding(5)
                  .frame(alignment: .topTrailing)
              }
            }
          }
          .contextMenu {
            InterestStatusPicker(selection: statusBinding)
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
  @Previewable @State var movies: [any DiscoverItem]? = [DiscoverMovieItem.default]

  NavigationStack {
    SimpleMediaItemListView(results: $movies) { _, _ in
      print("Updated Item")
    } onLastAppeared: {
      print("Last appeared")
    }
  }
  .environment(moviesRepository)
  .environment(tvSeriesRepository)
  .environment(personRepository)
}
