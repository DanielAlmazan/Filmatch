//
//  ContentView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import SwiftUI

/// `ContentView` is the root view of the application.
/// It decides whether to show the welcome screen or the main home screen based on the user's authentication status.
struct ContentView: View {
  /// The authentication view model to manage user authentication state.
  var authVm: AuthenticationViewModel
  
  var body: some View {
    VStack {
      if authVm.user == nil {
        // Show the welcome view if the user is not authenticated.
        WelcomeView(authVm: authVm)
      } else {
        // Show the home view if the user is authenticated.
        HomeView(authVm: authVm, repository: TMDBRepository())
      }
    }
  }
}

#Preview {
  ContentView(authVm: AuthenticationViewModel())
}
