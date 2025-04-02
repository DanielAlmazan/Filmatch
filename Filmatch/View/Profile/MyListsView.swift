//
//  MyListsView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 30/3/25.
//

import SwiftUI

struct MyListsView: View {
  let user: OtterMatchUser
  let media: MediaType
  let height: CGFloat
  @State var profileVm: ProfileViewModel

  var body: some View {
    VStack {
      MediaSelector(selectedMedia: self.$profileVm.selectedMedia)

      ScrollView {
        VStack {
          Group {
            ProfileMediaCardRowContainer(
              user: user,
              status: .superInterested,
              media: media,
              height: height,
              isLoading: self.$profileVm.isSuperHypedLoading,
              items: self.profileVm.superHypedItems
            )

            ProfileMediaCardRowContainer(
              user: user,
              status: .interested,
              media: media,
              height: height,
              isLoading: self.$profileVm.isWatchlistLoading,
              items: self.profileVm.watchlistItems
            )

            ProfileMediaCardRowContainer(
              user: user,
              status: .watched,
              media: media,
              height: height,
              isLoading: self.$profileVm.isWatchedLoading,
              items: self.profileVm.watchedItems
            )

            ProfileMediaCardRowContainer(
              user: user,
              status: .notInterested,
              media: media,
              height: height,
              isLoading: self.$profileVm.isBlacklistLoading,
              items: self.profileVm.blacklistItems
            )
          }
          .foregroundStyle(.onBgBase)
          .padding()
          .background(.bgContainer)
          .clipShape(.rect(cornerRadius: 10))
          .padding(.horizontal)
        }
      }
    }
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle("My Lists")
  }
}

#Preview {
  @Previewable let otterMatchRepository = OtterMatchGoRepositoryImpl(
    datasource: OtterMatchGoDatasourceImpl(
      client: OtterMatchHttpClient()
    )
  )
  @Previewable @State var profileVm = ProfileViewModel(
    user: .default,
    otterMatchRepository: OtterMatchGoRepositoryImpl(
      datasource: JsonOtterMatchDatasource(
        client: TMDBJsonClient()
      )
    ),
    filtersRepository: FiltersRepositoryImpl(
      filtersDatasource: JsonFiltersDatasource()
    )
  )
  NavigationStack {
    MyListsView(
      user: .default,
      media: .movie,
      height: 120,
      profileVm: profileVm)
  }
  .environment(otterMatchRepository)
}
