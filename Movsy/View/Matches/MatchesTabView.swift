//
//  MatchesTabView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import SwiftUI

struct MatchesTabView: View {
  @State var matchesVm: MatchesViewModel
  @State private var isPresentingLists: Bool = false

  init(repository: MovsyGoRepository) {
    self.matchesVm = .init(repository: repository)
  }

  var body: some View {
    VStack(spacing: 10) {
      MediaSelector(selectedMedia: $matchesVm.selectedMedia)
      
      SearchField(query: self.$matchesVm.query) {
        self.matchesVm.onSubmitQuery()
      }
      .padding(.horizontal)

      if let results = matchesVm.results, !results.isEmpty {
        ScrollView {
          LazyVStack(spacing: 10) {
            ForEach(results) { result in
              MatchesWithFriendContainerView(
                friendMatch: result,
                mediaType: self.matchesVm.selectedMedia,
                rootRefresh: onRefresh,
              ) {
                if results.last == result {
                  loadMoreSimpleFriendMatches()
                }
              } onLastItemAppeared: {
                loadMoreDetailMatchItems()
              }
              .padding()
              .background(.bgContainer)
              .clipShape(.rect(cornerRadius: 10))
              .frame(height: 200)
            }
          }
        }
        .padding(.horizontal)
        .refreshable { onRefresh() }
      }
      
      if matchesVm.isLoadingSimpleFriendsMatches {
        ProgressView()
      } else if matchesVm.results?.isEmpty ?? true {
        Text("No matches found… maybe you haven’t dared to add any friends yet?")
          .padding()
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle("Matches")
    .task { await initializeList() }
    .onChange(of: matchesVm.selectedMedia) {
      Task { await initializeList() }
    }
  }

  private func onRefresh() {
    Task { await self.matchesVm.onRefresh() }
  }

  private func loadMoreSimpleFriendMatches() {
    Task {
      await self.matchesVm.fetchMoreSimpleFriendMatches()
    }
  }
  
  private func loadMoreDetailMatchItems() {
    Task {
      if !self.matchesVm.isLoadingSimpleFriendsMatches {
        await self.matchesVm.fetchMoreSimpleFriendMatches()
      }
    }
  }

  private func initializeList() async {
    if self.matchesVm.results != nil { return }
    await self.matchesVm.fetchSimpleFriendsMatches()
  }
}

#Preview {
  let repository = MovsyGoRepositoryImpl(
    datasource: JsonMovsyDatasource(
      client: TMDBJsonClient()
    )
  )

  let movieRepository = MoviesRepositoryImpl(datasource: JsonMoviesRemoteDatasource())
  let tvRepository = TvSeriesRepositoryImpl(datasource: JsonTvSeriesDatasource())
  
  NavigationStack {
    MatchesTabView(repository: repository)
  }
  .environment(movieRepository)
  .environment(tvRepository)
  .environment(repository)
}
