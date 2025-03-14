//
//  ProfileSummary.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 13/8/24.
//

import SwiftUI

struct ProfileSummary: View {
  let kRowsHeight: CGFloat = 90
  private var user: OtterMatchUser

  @State private var profileVm: ProfileViewModel
  @State private var friendsVm: FriendsViewModel

  init(
    user: OtterMatchUser,
    otterMatchRepository: OtterMatchGoRepositoryImpl,
    filtersRepository: FiltersRepository,
    friendsVm: FriendsViewModel
  ) {
    self.user = user
    self.profileVm = .init(
      user: user,
      otterMatchRepository: otterMatchRepository,
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
      Group {
        ProfileMediaCardRowContainer(
          title: "Liked",
          height: kRowsHeight,
          isLoading: self.$profileVm.areLikedLoading,
          items: self.profileVm.likedItems,
          onLastAppeared: { onLastAppeared(for: .interested) }
        )
        
        ProfileMediaCardRowContainer(
          title: "Disliked",
          height: kRowsHeight,
          isLoading: self.$profileVm.areDislikedLoading,
          items: self.profileVm.dislikedItems,
          onLastAppeared: { onLastAppeared(for: .notInterested) }
        )
      }
      .foregroundStyle(.onBgBase)
      .padding()
      .background(.bgContainer)
      .clipShape(.rect(cornerRadius: 10))
    }
    .scrollClipDisabled()
    .padding()
    .navigationTitle(Text(user.username ?? "Profile"))
    .task {
//      await self.profileVm.loadProviders()
      await self.friendsVm.loadFriends()
      // await self.profileVm.loadSuperLikedItems()
      await self.profileVm.loadItems(for: .interested)
      // await self.profileVm.loadWatchedItems()
      await self.profileVm.loadItems(for: .notInterested)
    }
  }
  
  private func onLastAppeared(for status: InterestStatus) {
    Task {
      await self.profileVm.loadMoreItems(for: status)
    }
  }
}

#Preview {
  @Previewable let moviesRepository = MoviesRepositoryImpl(
    datasource: JsonMoviesRemoteDatasource()
  )

  @Previewable let otterMatchRepository = OtterMatchGoRepositoryImpl(
    datasource: OtterMatchGoDatasourceImpl(
      client: OtterMatchHttpClient()
    )
  )
  @Previewable let filtersRepository = FiltersRepositoryImpl(
    filtersDatasource: JsonFiltersDatasource()
  )
  @Previewable var friendsVm = FriendsViewModel(
    otterMatchRepository: OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(
        client: OtterMatchHttpClient()
      )
    )
  )

  NavigationStack {
    VStack {
      ProfileSummary(
        user: .default,
        otterMatchRepository: otterMatchRepository,
        filtersRepository: filtersRepository,
        friendsVm: friendsVm
      )
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.bgBase)
    .environment(moviesRepository)
    .environment(otterMatchRepository)
    .environment(filtersRepository)
    .environment(friendsVm)
  }
}
