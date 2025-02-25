//
//  ProfileSummary.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 13/8/24.
//

import SwiftUI

struct ProfileSummary: View {
  let kRowsHeight: CGFloat = 90
  private var user: OtterMatchUser

  @State private var profileVm: ProfileViewModel

  init(
    user: OtterMatchUser,
    otterMatchRepository: OtterMatchGoRepositoryImpl,
    filtersRepository: FiltersRepository
  ) {
    self.user = user
    self.profileVm = .init(
      user: user,
      otterMatchRepository: otterMatchRepository,
      filtersRepository: filtersRepository
    )
  }

  var body: some View {
    VStack(spacing: 10) {
      SimpleUserInfoView(user: self.user, size: 100)
  
      // MARK: - Friends
      ProfileFriendsContainer(
        title: "My Friends",
        height: kRowsHeight,
        isLoading: self.$profileVm.areFriendsLoading,
        friends: self.$profileVm.friends)

      // MARK: - Own lists
      Group {
        // 'My providers', 'superLike' and 'watched' are not available right now

        // VStack(alignment: .leading) {
        //   Text("Platforms")
        //   Group {
        //     if self.profileVm.areProvidersLoading {
        //       ProgressView("Loading...")
        //     } else if let providers = profileVm.providers {
        //       ProvidersRow(providers: providers, maxWidth: 80)
        //     }
        //   }
        //   .frame(height: kRowsHeight)
        // }

        // ProfileMediaCardRowContainer(
        //   title: "Super Liked",
        //   height: kRowsHeight,
        //   isLoading: self.$profileVm.areSuperLikedLoading,
        //   items: self.$profileVm.superLikedItems
        // )

        ProfileMediaCardRowContainer(
          title: "Liked",
          height: kRowsHeight,
          isLoading: self.$profileVm.areLikedLoading,
          items: self.$profileVm.likedItems
        )

        // ProfileMediaCardRowContainer(
        //   title: "Watched",
        //   height: kRowsHeight,
        //   isLoading: self.$profileVm.areWatchedLoading,
        //   items: self.$profileVm.watchedItems
        // )

        ProfileMediaCardRowContainer(
          title: "Disliked",
          height: kRowsHeight,
          isLoading: self.$profileVm.areDislikedLoading,
          items: self.$profileVm.dislikedItems
        )
      }
      .foregroundStyle(.onBgBase)
      .padding()
      .background(.bgContainer)
      .clipShape(.rect(cornerRadius: 10))
    }
    .scrollClipDisabled()
    .padding()
    .task {
      await self.profileVm.loadFriends(at: 1)
      await self.profileVm.loadProviders()
      // await self.profileVm.loadSuperLikedItems()
      await self.profileVm.loadLikedItems()
      // await self.profileVm.loadWatchedItems()
      await self.profileVm.loadDislikedItems()
    }
  }
}

#Preview {
  @Previewable let otterMatchRepository = OtterMatchGoRepositoryImpl(
    datasource: OtterMatchGoDatasourceImpl(
      client: OtterMatchHttpClient()
    )
  )
  @Previewable let filtersRepository = FiltersRepositoryImpl(
    filtersDatasource: JsonFiltersDatasource()
  )

  VStack {
    ProfileSummary(
      user: .default,
      otterMatchRepository: otterMatchRepository,
      filtersRepository: filtersRepository
    )
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
}
