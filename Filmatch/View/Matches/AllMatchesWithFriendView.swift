//
//  AllMatchesWithFriendView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import SwiftUI

struct AllMatchesWithFriendView: View {
  @State private var detailMatchesVm: DetailMatchesViewModel

  private var matches: [Match]? {
    self.detailMatchesVm.matches
  }
  let rootRefresh: () -> Void
  let onLastAppeared: () -> Void

  init(
    repository: OtterMatchGoRepository,
    matches: [Match]?,
    mediaType: MediaType,
    simpleFriendMatch: SimpleFriendMatch,
    rootRefresh: @escaping () -> Void,
    onLastAppeared: @escaping () -> Void,
  ) {
    self.detailMatchesVm = DetailMatchesViewModel(
      repository: repository,
      mediaType: mediaType,
      simpleFriendMatch: simpleFriendMatch
    )
    self.rootRefresh = rootRefresh
    self.onLastAppeared = onLastAppeared
  }

  @State var isGridSelected: Bool = true

  var body: some View {
    VStack {
      HStack {
        SearchField(
          query: $detailMatchesVm.query,
          onSubmit: self.detailMatchesVm.onSearchSubmit)
        GridSelectorButton(isGridSelected: $isGridSelected)
      }
      .padding(.horizontal)

      ScrollView {
        if let matches = self.detailMatchesVm.matches {
          Group {
            if isGridSelected {
              MatchesGridView(matches: matches, onLastAppeared: onLastAppeared)
            } else {
              MatchesListView(matches: matches, onLastAppeared: onLastAppeared)
            }
          }
          .padding(.horizontal)
          .animation(.bouncy, value: isGridSelected)
          if self.detailMatchesVm.isLoading {
            ProgressView()
          }
        }
      }
      .refreshable {
        rootRefresh()
        onRefresh()
      }
    }
    .task { await firstCallToApi() }
  }

  private func onRefresh() {
    Task {
      await self.detailMatchesVm.onRefresh()
    }
  }

  private func firstCallToApi() async {
    if self.detailMatchesVm.currentPage == 1 {
      await self.detailMatchesVm.fetchMatches()
    }
  }
}

#Preview {
  let otterMatchRepository = OtterMatchGoRepositoryImpl(
    datasource: JsonOtterMatchDatasource(client: TMDBJsonClient()))
  let movieRepository = MoviesRepositoryImpl(
    datasource: JsonMoviesRemoteDatasource())
  let tvRepository = TvSeriesRepositoryImpl(
    datasource: JsonTvSeriesDatasource())
  let personRepository = PersonRepositoryImpl(
    datasource: JsonPersonRemoteDatasource())

  NavigationStack {
    AllMatchesWithFriendView(
      repository: otterMatchRepository,
      matches: [.movieMock],
      mediaType: .movie,
      simpleFriendMatch: .default
    ) {
      print("Refresh root")
    } onLastAppeared: {
      print("Last appeared")
    }
    .navigationTitle("gas_esnake")
    .background(.bgBase)
  }
  .environment(movieRepository)
  .environment(tvRepository)
  .environment(personRepository)
}
