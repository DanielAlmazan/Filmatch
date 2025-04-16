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

  @State private var friendsVm: FriendsViewModel

  init(
    user: MovsyUser,
    movsyRepository: MovsyGoRepositoryImpl,
    filtersRepository: FiltersRepository,
    friendsVm: FriendsViewModel
  ) {
    self.user = user
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
    }
    .navigationTitle(Text(user.username ?? "Profile"))
    .task {
      await initFriends()
    }
  }
  
  private func initFriends() async {
    if self.friendsVm.friends?.isEmpty ?? true {
      await self.friendsVm.loadFriends()
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
