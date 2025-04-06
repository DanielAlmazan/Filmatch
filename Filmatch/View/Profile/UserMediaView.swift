//
//  UserMediaView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 12/3/25.
//

import SwiftUI

struct UserMediaView: View {
  @State private var myListVm: MyListViewModel

  let status: InterestStatus

  init(
    repository: OtterMatchGoRepository,
    user: OtterMatchUser?,
    status: InterestStatus,
    media: MediaType,
    items: [any DiscoverItem]
  ) {
    self.myListVm = MyListViewModel(
      user: user,
      repository: repository,
      status: status,
      media: media,
      items: items)
    self.status = status
  }

  @State private var isGridSelected: Bool = true

  var body: some View {
    VStack {
      HStack {
        SearchField(query: self.$myListVm.query) {
          Task {
            await self.myListVm.onSubmitQuery()
          }
        }
        GridSelectorButton(isGridSelected: $isGridSelected)
      }
      if let items = myListVm.items {
        if isGridSelected {
          SimpleMediaItemsGridView(results: items) {
            onLastAppeared()
          }
        } else {
          SimpleMediaItemListView(results: items) {
            onLastAppeared()
          }
        }
      }
    }
    .animation(.bouncy, value: isGridSelected)
    .padding(.horizontal)
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle(status.listName)
  }

  private func onLastAppeared() {
    Task {
      await self.myListVm.getMoreItems()
    }
  }
}

#Preview {
  @Previewable @State var moviesRepository = MoviesRepositoryImpl(
    datasource: MoviesRemoteDatasourceImpl(
      client: TMDBHttpClient()
    )
  )

  @Previewable @State var tvRepository = TvSeriesRepositoryImpl(
    datasource: TvSeriesDatasourceImpl(
      client: TMDBHttpClient()
    )
  )

  @Previewable @State var personRepository = PersonRepositoryImpl(
    datasource: PersonDatasourceImpl(
      client: TMDBHttpClient()
    )
  )

  @Previewable @State var movie = DiscoverMovieItem.default

  let otterMatchRepository = OtterMatchGoRepositoryImpl(datasource: JsonOtterMatchDatasource(client: TMDBJsonClient()))

  NavigationStack {
    UserMediaView(
      repository: otterMatchRepository, user: .default, status: .interested, media: .movie,
      items: [movie])
    .onAppear { movie.status = .superInterested }
  }
  .environment(moviesRepository)
  .environment(tvRepository)
  .environment(personRepository)
}
