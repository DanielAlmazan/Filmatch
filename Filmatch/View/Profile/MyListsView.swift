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
              status: .superInterested,
              media: media,
              height: height,
              isLoading: self.$profileVm.isSuperHypedLoading,
              items: self.$profileVm.superHypedItems,
              updateItem: updateItem
            )

            ProfileMediaCardRowContainer(
              status: .interested,
              media: media,
              height: height,
              isLoading: self.$profileVm.isWatchlistLoading,
              items: self.$profileVm.watchlistItems,
              updateItem: updateItem
            )

            ProfileMediaCardRowContainer(
              status: .watched,
              media: media,
              height: height,
              isLoading: self.$profileVm.isWatchedLoading,
              items: self.$profileVm.watchedItems,
              updateItem: updateItem
            )

            ProfileMediaCardRowContainer(
              status: .notInterested,
              media: media,
              height: height,
              isLoading: self.$profileVm.isBlacklistLoading,
              items: self.$profileVm.blacklistItems,
              updateItem: updateItem
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
    .task { await initLists() }
  }

  private func updateItem(_ item: any DiscoverItem, as status: InterestStatus?) {
    guard let status = status else { return }

    Task {
      await self.profileVm.updateItem(item, for: status)
    }
  }

  private func initLists() async {
    if profileVm.watchedItems?.isEmpty ?? true {
      await profileVm.loadItems(for: .watched)
    }
    if profileVm.blacklistItems?.isEmpty ?? true {
      await profileVm.loadItems(for: .notInterested)
    }
    if profileVm.watchlistItems?.isEmpty ?? true {
      await profileVm.loadItems(for: .interested)
    }
    if profileVm.superHypedItems?.isEmpty ?? true {
      await profileVm.loadItems(for: .superInterested)
    }
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
  .environment(
    AuthenticationViewModel(
      authenticationRepository: AuthenticationFirebaseRepository(
        dataSource: AuthenticationFirebaseDataSource()
      ),
      otterMatchRepository: OtterMatchGoRepositoryImpl(
        datasource: OtterMatchGoDatasourceImpl(
          client: OtterMatchHttpClient(
            urlBase: API.otterMatchBaseURL)
        )
      )
    )
  )
}
