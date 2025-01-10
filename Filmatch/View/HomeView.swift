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

  var body: some View {
    TabView(selection: $selectedTab) {
      // MARK: - Discover Tab
      /// Tab for discovering movies.
      Tab("Discover", systemImage: "star", value: 0) {
        DiscoverView(moviesRepository: moviesRepository,
                           tvSeriesRepository: tvSeriesRepository,
                           filtersRepository: filtersRepository)
      }

      Tab("Search", systemImage: "magnifyingglass", value: 1) {
        Text("Search view")
      }

      // MARK: - Rooms Tab
      /// Tab for managing and joining rooms.
      Tab(value: 2) {
        Text("Matches view")
      } label: {
        // Custom label with an image and text for the Rooms tab.
        Image(.filmatchLogoTabItem)
        Text("Matches")
      }

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
        ProfileTab(authVm: authVm)
      }
    }
  }
}

#Preview {
  @Previewable @State var authVm = AuthenticationViewModel()
  @Previewable @State var moviesRepository = MoviesRepositoryImpl(remoteDatasource: JsonMoviesRemoteDatasource())
                                                           
  @Previewable @State var filtersRepository = FiltersRepositoryImpl(filtersDatasource: JsonFiltersDatasource())
                                                                   
  HomeView()
    .environment(authVm)
    .environment(moviesRepository)
    .environment(filtersRepository)
}
