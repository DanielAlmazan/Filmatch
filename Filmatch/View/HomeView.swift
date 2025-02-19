//
//  HomeView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import SwiftUI

/// `HomeView` is the main container view for the Filmatch app, providing a tab-based navigation interface.
/// It includes tabs for discovering movies, managing rooms, and viewing the user's profile.
/// This view manages the selection state of the tabs and passes necessary dependencies to child views.
struct HomeView: View {
  /// The index of the currently selected tab.
  @State var selectedTab = 0

  /// The authentication view model used for user authentication and profile management.
  @Environment(AuthenticationViewModel.self) var authVm

  /// The movies repository used to fetch and provide movie data.
  @Environment(MoviesRepositoryImpl.self) private var moviesRepository

  @Environment(TvSeriesRepositoryImpl.self) private var tvSeriesRepository

  @Environment(FiltersRepositoryImpl.self) private var filtersRepository
  
  @Environment(FilmatchGoRepositoryImpl.self) private var filmatchGoRepository
  
  var body: some View {
    TabView(selection: $selectedTab) {
      // MARK: - Discover Tab
      /// Tab for discovering movies.
      Tab(value: 0) {
        NavigationStack {
          DiscoverView(
            moviesRepository: moviesRepository,
            tvSeriesRepository: tvSeriesRepository,
            filmatchRepository: filmatchGoRepository,
            filtersRepository: filtersRepository
          ) { item, status in
            Task {
              // TODO: Show error if exists
              let _ = await filmatchGoRepository.markMediaAsVisited(for: item, as: status)
            }
          }
          .background(.bgBase)
        }
      } label: {
        Image(.discoverTabIcon)
        Text("Discover")
      }

      // MARK: - Search Tab
      Tab("Search", systemImage: "magnifyingglass", value: 1) {
        NavigationStack {
          SearchView(moviesRepository: moviesRepository, tvSeriesRepository: tvSeriesRepository)
            .background(.bgBase)
        }
      }

      // MARK: - Matches Tab
      Tab(value: 2) {
        VStack {
          Text("Matches view")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bgBase)
      } label: {
        Image(.matchesTabIcon)
          .resizable(resizingMode: .stretch)
        Text("Matches")
      }

      // MARK: - Rooms Tab
      /// Tab for managing and joining rooms.
      Tab(value: 3) {
        RoomsMainView()
      } label: {
        // Custom label with an image and text for the Rooms tab.
        Image(.filmatchLogoTabItem)
        Text("Rooms")
      }

      // MARK: - Profile Tab
      /// Tab for viewing and editing the user's profile.
      Tab("Profile", systemImage: "person.crop.circle", value: 4) {
        ProfileTab()
          .background(.bgBase)
          .environment(authVm)
          .environment(filmatchGoRepository)
      }
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
  @Previewable @State var authVm = AuthenticationViewModel(authenticationRepository: AuthenticationFirebaseRepository(dataSource: AuthenticationFirebaseDataSource()), filmatchRepository: FilmatchGoRepositoryImpl(datasource: FilmatchGoDatasourceImpl(client: FilmatchHttpClient(urlBase: AppConstants.filmatchBaseUrl))))

  @Previewable @State var filmatchGoRepository = FilmatchGoRepositoryImpl(
    datasource: FilmatchGoDatasourceImpl(
      client: FilmatchHttpClient(
        urlBase: AppConstants.filmatchBaseUrl
      )
    )
  )

  HomeView()
    .environment(authVm)
    .environment(moviesRepository)
    .environment(filtersRepository)
    .environment(tvSeriesRepository)
    .environment(filmatchGoRepository)
}
