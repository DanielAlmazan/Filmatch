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
  var authVm: AuthenticationViewModel
  
  /// The movies repository used to fetch and provide movie data.
  var repository: MoviesRepository

  var body: some View {
    TabView(selection: $selectedTab) {
      // MARK: - Discover Tab
      /// Tab for discovering movies.
      Tab("Discover", systemImage: "star", value: 0) {
        DiscoverMoviesView(repository: repository)
      }

      // MARK: - Rooms Tab
      /// Tab for managing and joining rooms.
      Tab(value: 1) {
        RoomsMainView()
      } label: {
        // Custom label with an image and text for the Rooms tab.
        Image(.filmatchLogoTabItem)
        Text("Rooms")
      }

      // MARK: - Profile Tab
      /// Tab for viewing and editing the user's profile.
      Tab("Profile", systemImage: "person.crop.circle", value: 2) {
        ProfileTab(authVm: authVm)
      }
    }
  }
}

#Preview {
  HomeView(authVm: AuthenticationViewModel(), repository: JsonPresetRepository())
}
