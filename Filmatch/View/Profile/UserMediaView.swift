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
  let updateItem: (any DiscoverItem, InterestStatus?) -> Void
  let onRefresh: () -> Void

  init(
    repository: OtterMatchGoRepository,
    user: OtterMatchUser?,
    status: InterestStatus,
    media: MediaType,
    items: [any DiscoverItem],
    updateItem: @escaping (any DiscoverItem, InterestStatus?) -> Void,
    onRefresh: @escaping () -> Void,
  ) {
    self.myListVm = MyListViewModel(
      user: user,
      repository: repository,
      status: status,
      media: media,
      items: items)
    self.status = status
    self.updateItem = updateItem
    self.onRefresh = onRefresh
  }

  @State private var isGridSelected: Bool = true

  var body: some View {
    ScrollView {
      VStack {
        HStack {
          SearchField(query: self.$myListVm.query) {
            Task {
              await self.myListVm.onSubmitQuery()
            }
          }
          GridSelectorButton(isGridSelected: $isGridSelected)
        }
        if let _ = myListVm.items {
          if isGridSelected {
            SimpleMediaItemsGridView(results: $myListVm.items, updateItem: updateItem, onLastAppeared: onLastAppeared)
          } else {
            SimpleMediaItemListView(results: $myListVm.items, updateItem: updateItem, onLastAppeared: onLastAppeared)
          }
        }
      }
      .animation(.bouncy, value: isGridSelected)
      .padding(.horizontal)
      .frame(maxHeight: .infinity, alignment: .top)
      .navigationTitle(status.listName)
    }
    .refreshable {
      onRefresh()
      Task {
        await myListVm.onRefresh()
      }
    }
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
    ScrollView {
      UserMediaView(
        repository: otterMatchRepository, user: .default, status: .interested, media: .movie,
        items: [movie]) { _, _ in
          print("Updating item...")
        } onRefresh: {
          print("Refreshing...")
        }
      .onAppear { movie.status = .superInterested }
    }
  }
  .environment(moviesRepository)
  .environment(tvRepository)
  .environment(personRepository)
}
