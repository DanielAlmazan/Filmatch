//
//  UserMediaView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 12/3/25.
//

import SwiftUI

struct UserMediaView: View {
  let title: String
  var items: [any DiscoverItem]
  let onLastAppeared: () -> Void

  @State private var isGridSelected: Bool = true

  var body: some View {
    VStack {
      if isGridSelected {
        SimpleMediaItemsGridView(results: items, action: onLastAppeared)
      } else {
        SimpleMediaItemListView(results: items, onLastAppeared: onLastAppeared)
      }
    }
    .animation(.bouncy, value: isGridSelected)
    .padding(.horizontal)
    .navigationTitle(title)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          withAnimation {
            isGridSelected.toggle()
          }
        }) {
          GridSelectorButton(isGridSelected: $isGridSelected)
        }
      }
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
  
  NavigationStack {
    UserMediaView(
      title: "Liked",
      items: [DiscoverMovieItem.default],
      onLastAppeared: {}
    )
  }
  .environment(moviesRepository)
  .environment(tvRepository)
  .environment(personRepository)
}
