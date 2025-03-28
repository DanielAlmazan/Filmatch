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
//    .scrollClipDisabled()
    .navigationTitle(Text(user.username ?? "Profile"))
    .task { await initLists() }
  }
  
  private func onLastAppeared(for status: InterestStatus) {
    Task {
      await self.profileVm.loadMoreItems(for: status)
    }
  }
  
  private func initLists() async {
//    if self.profileVm.providers == nil || self.profileVm.providers!.isEmpty {
//      await self.profileVm.loadProviders()
//    }
    if self.friendsVm.friends == nil || self.friendsVm.friends!.isEmpty {
      await self.friendsVm.loadFriends()
    }
//    if self.profileVm.superLikedItems == nil || self.profileVm.superLikedItems!.isEmpty {
//      await self.profileVm.loadItems(for: .superInterested)
//    }
    if self.profileVm.likedItems == nil || self.profileVm.likedItems!.isEmpty {
      await self.profileVm.loadItems(for: .interested)
    }
//    if self.profileVm.watchedItems == nil || self.profileVm.watchedItems!.isEmpty {
//      await self.profileVm.loadItems(for: .watched)
//    }
    if self.profileVm.dislikedItems == nil || self.profileVm.dislikedItems!.isEmpty {
      await self.profileVm.loadItems(for: .notInterested)
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
    .padding()
    .background(.bgBase)
    .environment(moviesRepository)
    .environment(otterMatchRepository)
    .environment(filtersRepository)
    .environment(friendsVm)
  }
}
