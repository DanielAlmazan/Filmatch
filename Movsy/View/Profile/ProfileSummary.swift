//
//  ProfileSummary.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 13/8/24.
//

import SwiftUI

struct ProfileSummary: View {
  let kRowsHeight: CGFloat = 90
  private var user: MovsyUser

  @State private var profileVm: ProfileViewModel
  @State private var friendsVm: FriendsViewModel

  init(
    user: MovsyUser,
    movsyRepository: MovsyGoRepositoryImpl,
    filtersRepository: FiltersRepository,
    friendsVm: FriendsViewModel
  ) {
    self.user = user
    self.profileVm = .init(
      user: user,
      movsyRepository: movsyRepository,
      filtersRepository: filtersRepository
    )
    self.friendsVm = friendsVm
  }

  var body: some View {
    VStack(spacing: 10) {
      UserAvatarView(user: user, size: 100)
        .shadow(radius: 5, y: 5)

      // MARK: - Friends
      ProfileFriendsContainer(
        title: "My Friends",
        height: kRowsHeight,
        isLoading: self.$friendsVm.isLoadingFriends,
        friends: self.$friendsVm.friends)

      // MARK: - Own lists
      NavigationLink {
        MyListsView(
          user: self.user,
          media: self.profileVm.selectedMedia,
          height: kRowsHeight * 1.6,
          profileVm: self.profileVm
        )
        .background(.bgBase)
      } label: {
        HStack {
          Text("My lists")
            .foregroundColor(.primary)
          Spacer()
          Image(systemName: "chevron.right")
            .foregroundColor(.secondary)
        }
        .padding()
        .background(.bgContainer)
        .clipShape(.rect(cornerRadius: 10))
      }
    }
    .navigationTitle(Text(user.username ?? "Profile"))
    .task {
      await initFriends()
      await initMyLists()
    }
    .onChange(of: self.profileVm.selectedMedia) {
      self.profileVm.onSelectedMediaChanged()
      Task { await initMyLists() }
    }
  }
  
  private func onLastAppeared(for status: InterestStatus) {
    Task {
      await self.profileVm.loadMoreItems(for: status)
    }
  }
  
  private func initFriends() async {
    if self.friendsVm.friends?.isEmpty ?? true {
      await self.friendsVm.loadFriends()
    }
  }

  private func initMyLists() async {
//    if self.profileVm.providers?.isEmpty ?? true {
//      await self.profileVm.loadProviders()
//    }
    if self.profileVm.superHypedItems?.isEmpty ?? true {
      await self.profileVm.loadItems(for: .superInterested)
    }
    if self.profileVm.watchlistItems?.isEmpty ?? true {
      await self.profileVm.loadItems(for: .interested)
    }
    if self.profileVm.watchedItems?.isEmpty ?? true {
      await self.profileVm.loadItems(for: .watched)
    }
    if self.profileVm.blacklistItems?.isEmpty ?? true {
      await self.profileVm.loadItems(for: .notInterested)
    }
  }
}

#Preview {
  @Previewable let moviesRepository = MoviesRepositoryImpl(
    datasource: JsonMoviesRemoteDatasource()
  )

  @Previewable let movsyRepository = MovsyGoRepositoryImpl(
    datasource: MovsyGoDatasourceImpl(
      client: MovsyHttpClient()
    )
  )
  @Previewable let filtersRepository = FiltersRepositoryImpl(
    filtersDatasource: JsonFiltersDatasource()
  )
  @Previewable var friendsVm = FriendsViewModel(
    movsyRepository: MovsyGoRepositoryImpl(
      datasource: JsonMovsyDatasource(
        client: TMDBJsonClient()
      )
    )
  )

  NavigationStack {
    VStack {
      ProfileSummary(
        user: .default,
        movsyRepository: movsyRepository,
        filtersRepository: filtersRepository,
        friendsVm: friendsVm
      )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .padding()
    .background(.bgBase)
    .environment(moviesRepository)
    .environment(movsyRepository)
    .environment(filtersRepository)
    .environment(friendsVm)
  }
}
