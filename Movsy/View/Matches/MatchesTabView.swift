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

  let redirectToProfile: () -> Void

  @Environment(FriendsViewModel.self) var friendsVm

  init(repository: MovsyGoRepository, redirectToProfile: @escaping () -> Void) {
    self.matchesVm = .init(repository: repository)
    self.redirectToProfile = redirectToProfile
  }

  var body: some View {
    if !friendsVm.isLoadingFriends && (friendsVm.friends?.isEmpty ?? true) {
      VStack {
        Text("Matches come after friends…")
          .font(.headline)
        Text("Try adding some friends to see matches!")
        Text("You can add friends from the profile tab.")

        Button("Go to Profile", action: redirectToProfile)
      }
    } else if friendsVm.isLoadingFriends {
      ProgressView()
    } else {
      VStack(spacing: 10) {
        MediaSelector(selectedMedia: $matchesVm.selectedMedia)

        SearchField(query: self.$matchesVm.query) {
          self.matchesVm.onSubmitQuery()
        }
        .padding(.horizontal)

        ScrollView {
          if matchesVm.isLoadingSimpleFriendsMatches {
            ProgressView()
          } else if matchesVm.results?.isEmpty ?? true {
            if self.matchesVm.query.isEmpty {
              Text("No matches found… maybe you should add some movies to your watchlist or super hype?")
                .padding()
            } else {
              Text("It seems there you have no matches with any \"\(self.matchesVm.query)\"…")
            }
          }

          if let results = matchesVm.results, !results.isEmpty {
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
        }
        .padding(.horizontal)
        .refreshable { onRefresh() }
      }
      .frame(maxHeight: .infinity, alignment: .top)
      .navigationTitle("Matches")
      .task {
        if let friends = self.friendsVm.friends, !friends.isEmpty {
          await initializeList()
        }
      }
      .onChange(of: matchesVm.selectedMedia) {
        onSelectedMediaChanged()
      }
    }
  }

  private func onSelectedMediaChanged() {
    Task { await self.matchesVm.onMediaSelectedChanged() }
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

#Preview("Matches – No Friends") {
  let repository = MovsyGoRepositoryImpl(
    datasource: JsonMovsyDatasource(
      client: TMDBJsonClient()
    )
  )

  let movieRepository = MoviesRepositoryImpl(datasource: JsonMoviesRemoteDatasource())
  let tvRepository = TvSeriesRepositoryImpl(datasource: JsonTvSeriesDatasource())
  let friendsVm = FriendsViewModel(
    movsyRepository: MovsyGoRepositoryImpl(
      datasource: JsonMovsyDatasource(
        client: TMDBJsonClient()
      )
    )
  )

  NavigationStack {
    MatchesTabView(repository: repository) { print("Redirecting to profile") }
  }
  .environment(movieRepository)
  .environment(tvRepository)
  .environment(repository)
  .environment(friendsVm)
}

#Preview("Matches – Friends") {
  let repository = MovsyGoRepositoryImpl(
    datasource: JsonMovsyDatasource(
      client: TMDBJsonClient()
    )
  )

  let movieRepository = MoviesRepositoryImpl(datasource: JsonMoviesRemoteDatasource())
  let tvRepository = TvSeriesRepositoryImpl(datasource: JsonTvSeriesDatasource())
  let friendsVm = FriendsViewModel(
    movsyRepository: MovsyGoRepositoryImpl(
      datasource: JsonMovsyDatasource(
        client: TMDBJsonClient()
      )
    )
  )

  NavigationStack {
    MatchesTabView(repository: repository) { print("Redirecting to profile") }
  }
  .task { await friendsVm.loadFriends() }
  .environment(movieRepository)
  .environment(tvRepository)
  .environment(repository)
  .environment(friendsVm)
}
