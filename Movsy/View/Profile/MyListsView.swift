//
//  MyListsView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 30/3/25.
//

import SwiftUI

struct MyListsView: View {
  let user: MovsyUser
  let height: CGFloat
  @State var profileVm: ProfileViewModel

  init(user: MovsyUser, height: CGFloat, movsyRepository: MovsyGoRepositoryImpl, filtersRepository: FiltersRepository) {
    self.user = user
    self.height = height
    self.profileVm = .init(user: user, movsyRepository: movsyRepository, filtersRepository: filtersRepository)
  }

  var body: some View {
    ScrollView {
      MediaSelector(selectedMedia: self.$profileVm.selectedMedia)

      VStack {
        Group {
          ProfileMediaCardRowContainer(
            status: .superHype,
            media: self.profileVm.selectedMedia,
            height: height,
            isLoading: self.$profileVm.isSuperHypedLoading,
            items: self.$profileVm.superHypedItems,
            updateItem: updateItem,
            onRefresh: onRefresh,
          )

          ProfileMediaCardRowContainer(
            status: .watchlist,
            media: self.profileVm.selectedMedia,
            height: height,
            isLoading: self.$profileVm.isWatchlistLoading,
            items: self.$profileVm.watchlistItems,
            updateItem: updateItem,
            onRefresh: onRefresh,
          )

          ProfileMediaCardRowContainer(
            status: .watched,
            media: self.profileVm.selectedMedia,
            height: height,
            isLoading: self.$profileVm.isWatchedLoading,
            items: self.$profileVm.watchedItems,
            updateItem: updateItem,
            onRefresh: onRefresh,
          )

          ProfileMediaCardRowContainer(
            status: .blacklist,
            media: self.profileVm.selectedMedia,
            height: height,
            isLoading: self.$profileVm.isBlacklistLoading,
            items: self.$profileVm.blacklistItems,
            updateItem: updateItem,
            onRefresh: onRefresh,
          )
        }
        .foregroundStyle(.onBgBase)
        .padding()
        .background(.bgContainer)
        .clipShape(.rect(cornerRadius: 10))
        .padding(.horizontal)
      }
    }
    .refreshable { onRefresh() }
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle("My Lists")
    .task { await initLists() }
    .onChange(of: self.profileVm.selectedMedia) {
      self.profileVm.onSelectedMediaChanged()
      Task { await initMyLists() }
    }
  }

  private func initMyLists() async {
    //    if self.profileVm.providers?.isEmpty ?? true {
    //      await self.profileVm.loadProviders()
    //    }
    if self.profileVm.superHypedItems?.isEmpty ?? true {
      await self.profileVm.loadItems(for: .superHype)
    }
    if self.profileVm.watchlistItems?.isEmpty ?? true {
      await self.profileVm.loadItems(for: .watchlist)
    }
    if self.profileVm.watchedItems?.isEmpty ?? true {
      await self.profileVm.loadItems(for: .watched)
    }
    if self.profileVm.blacklistItems?.isEmpty ?? true {
      await self.profileVm.loadItems(for: .blacklist)
    }
  }

  private func onRefresh() {
    Task {
      await self.profileVm.onRefresh(of: .watchlist)
      await self.profileVm.onRefresh(of: .superHype)
      await self.profileVm.onRefresh(of: .watched)
      await self.profileVm.onRefresh(of: .blacklist)
    }
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
      await profileVm.loadItems(for: .blacklist)
    }
    if profileVm.watchlistItems?.isEmpty ?? true {
      await profileVm.loadItems(for: .watchlist)
    }
    if profileVm.superHypedItems?.isEmpty ?? true {
      await profileVm.loadItems(for: .superHype)
    }
  }
}

#Preview {
  let movsyRepository = MovsyGoRepositoryImpl(
    datasource: MovsyGoDatasourceImpl(
      client: MovsyHttpClient()
    )
  )
  let filtersRepository = FiltersRepositoryImpl(
      filtersDatasource: JsonFiltersDatasource()
    )

  NavigationStack {
    MyListsView(user: .default, height: 120, movsyRepository: movsyRepository, filtersRepository: filtersRepository)
  }
  .environment(movsyRepository)
  .environment(
    AuthenticationViewModel(
      authenticationRepository: AuthenticationFirebaseRepository(
        dataSource: AuthenticationFirebaseDataSource()
      ),
          movsyRepository: MovsyGoRepositoryImpl(
        datasource: MovsyGoDatasourceImpl(
          client: MovsyHttpClient(
            urlBase: API.movsyBaseURL)
        )
      )
    )
  )
}
