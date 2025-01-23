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
  @Environment(AuthenticationViewModel.self) var authVm
  @State var moviesRepository: MoviesRepositoryImpl
  @State var tvSeriesRepository: TvSeriesRepositoryImpl
  @State var filtersRepository: FiltersRepositoryImpl
  @State var personRepository: PersonRepositoryImpl

  init() {
    let client = HttpClient()

    self.moviesRepository = .init(
      datasource: MoviesRemoteDatasourceImpl(client: client))
    
    self.tvSeriesRepository = .init(
      datasource: TvSeriesDatasourceImpl(client: client))

    self.filtersRepository = .init(
      filtersDatasource: FiltersRemoteDatasource(client: client))
    
    self.personRepository = .init(
      datasource: PersonDatasourceImpl(client: client)
    )
  }

  var body: some View {
    VStack {
      if authVm.currentUser == nil {
        // Show the welcome view if the user is not authenticated.
        WelcomeView()
      } else {
        // Show the home view if the user is authenticated.
        HomeView()
          .environment(moviesRepository)
          .environment(tvSeriesRepository)
          .environment(filtersRepository)
          .environment(personRepository)
      }
    }
  }
}

#Preview {
  @Previewable @State var authVm = AuthenticationViewModel(
    authenticationRepository: AuthenticationFirebaseRepository(
      dataSource: AuthenticationFirebaseDataSource.shared))
  ContentView()
    .environment(authVm)
}
