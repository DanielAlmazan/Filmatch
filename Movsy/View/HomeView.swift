//
//  HomeView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import SwiftUI

/// `HomeView` is the main container view for the Movsy app, providing a tab-based navigation interface.
/// It includes tabs for discovering movies, managing rooms, and viewing the user's profile.
/// This view manages the selection state of the tabs and passes necessary dependencies to child views.
struct HomeView: View {
  enum TabIndex: Int {
    case discover
    case search
    case matches
    case myLists
    case profile
  }
  /// The index of the currently selected tab.
  @State var selectedTab: TabIndex = .discover

  /// The authentication view model used for user authentication and profile management.
  @Environment(AuthenticationViewModel.self) var authVm

  /// The movies repository used to fetch and provide movie data.
  @Environment(MoviesRepositoryImpl.self) private var moviesRepository

  @Environment(TvSeriesRepositoryImpl.self) private var tvSeriesRepository

  @Environment(FiltersRepositoryImpl.self) private var filtersRepository
  
  @Environment(MovsyGoRepositoryImpl.self) private var movsyGoRepository
  
  @Environment(FriendsViewModel.self) var friendsVm

  var body: some View {
    TabView(selection: $selectedTab) {
      // MARK: - Discover Tab
      /// Tab for discovering movies.
      Tab(value: .discover) {
        NavigationStack {
          DiscoverView(
            moviesRepository: moviesRepository,
            tvSeriesRepository: tvSeriesRepository,
            movsyRepository: movsyGoRepository,
            filtersRepository: filtersRepository
          ) { item, status in
            Task {
              // TODO: Show error if exists
              let _ = await movsyGoRepository.markMediaAsVisited(for: item, as: status)
            }
          }
          .background(.bgBase)
        }
      } label: {
        Image(.discoverTabIcon)
        Text("Discover")
      }

      // MARK: - Search Tab
      Tab("Search", systemImage: "magnifyingglass", value: .search) {
        NavigationStack {
          SearchMediaView(moviesRepository: moviesRepository, tvSeriesRepository: tvSeriesRepository, movsyRepository: movsyGoRepository)
            .background(.bgBase)
        }
      }

      // MARK: - Matches Tab
      Tab(value: .matches) {
        NavigationStack {
          MatchesTabView(repository: movsyGoRepository)
            .background(.bgBase)
        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(.bgBase)
      } label: {
        Image(.matchesTabIcon)
          .resizable(resizingMode: .stretch)
        Text("Matches")
      }

      // MARK: - Rooms Tab
      /// Tab for managing and joining rooms.
//      Tab(value: .rooms) {
//        RoomsMainView()
//      } label: {
//        // Custom label with an image and text for the Rooms tab.
//        Image(.movsyLogoTabItem)
//        Text("Rooms")
//      }

      // MARK: - MyLists Tab
      Tab(value: .myLists) {
        NavigationStack {
          if let user = authVm.currentUser {
            MyListsView(
              user: user,
              height: 144,
              movsyRepository: movsyGoRepository,
              filtersRepository: filtersRepository)
          }
        }
      } label: {
        Image(systemName: "list.bullet")
        Text("My Lists")
      }

      // MARK: - Profile Tab
      /// Tab for viewing and editing the user's profile.
      Tab("Profile", systemImage: "person.crop.circle", value: .profile) {
        NavigationStack {
          ProfileTab()
            .background(.bgBase)
            .environment(authVm)
            .environment(movsyGoRepository)
        }
      }
      .badge(friendsVm.friendRequests?.count ?? 0)
    }
  }
}

#Preview {
  @Previewable @State var moviesRepository = MoviesRepositoryImpl(
    datasource: JsonMoviesRemoteDatasource()
//    remoteDatasource: MoviesRemoteDatasourceImpl(client: HttpClient())
  )
  @Previewable @State var tvSeriesRepository = TvSeriesRepositoryImpl(
    datasource: JsonTvSeriesDatasource()
//    remoteDatasource: TvSeriesDatasourceImpl(client: HttpClient())
  )
  @Previewable @State var filtersRepository = FiltersRepositoryImpl(
    filtersDatasource: JsonFiltersDatasource())
  @Previewable @State var authVm = AuthenticationViewModel(authenticationRepository: AuthenticationFirebaseRepository(dataSource: AuthenticationFirebaseDataSource()),     movsyRepository: MovsyGoRepositoryImpl(datasource: MovsyGoDatasourceImpl(client: MovsyHttpClient(urlBase: API.movsyBaseURL))))

  @Previewable @State var movsyGoRepository = MovsyGoRepositoryImpl(
    datasource: JsonMovsyDatasource(
      client: TMDBJsonClient()
    )
  )
  
  @Previewable @State var friendsVm = FriendsViewModel(
    movsyRepository: MovsyGoRepositoryImpl(
      datasource: MovsyGoDatasourceImpl(
        client: MovsyHttpClient()
      )
    )
  )

  HomeView()
    .environment(authVm)
    .environment(moviesRepository)
    .environment(filtersRepository)
    .environment(tvSeriesRepository)
    .environment(movsyGoRepository)
    .environment(friendsVm)
    .task { authVm.currentUser = .default }
}
