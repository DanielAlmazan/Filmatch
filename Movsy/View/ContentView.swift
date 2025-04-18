//
//  ContentView.swift
//  Movsy
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
  @State var movsyGoRepository: MovsyGoRepositoryImpl
  @State var friendsVm: FriendsViewModel

  init() {
    let client = TMDBHttpClient()

    self.moviesRepository = .init(
      datasource: MoviesRemoteDatasourceImpl(client: client))
    
    self.tvSeriesRepository = .init(
      datasource: TvSeriesDatasourceImpl(client: client))

    self.filtersRepository = .init(
      filtersDatasource: FiltersRemoteDatasource(client: client))
    
    self.personRepository = .init(
      datasource: PersonDatasourceImpl(client: client)
    )
    
    self.movsyGoRepository = .init(
      datasource: MovsyGoDatasourceImpl(
        client: MovsyHttpClient(urlBase: API.movsyBaseURL)
      )
    )
    
    self.friendsVm = .init(
      movsyRepository: MovsyGoRepositoryImpl(
        datasource: MovsyGoDatasourceImpl(
          client: MovsyHttpClient()
        )
      )
    )
  }

  var body: some View {
    VStack {
      if authVm.isLoading {
        ProgressView("Checking user...")
      } else if let user = authVm.currentUser, user.isVerified {
        // Show the home view if the user is authenticated.
        HomeView()
          .environment(moviesRepository)
          .environment(tvSeriesRepository)
          .environment(filtersRepository)
          .environment(personRepository)
          .environment(movsyGoRepository)
          .environment(friendsVm)
          .task {
            if friendsVm.friendRequests == nil && !friendsVm.isLoadingRequests {
              await friendsVm.loadFriendRequests()
            }
          }
      } else {
        // Show the welcome view if the user is not authenticated.
        WelcomeView()
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.bgBase)

  }
}

#Preview {
  @Previewable @State var authVm = AuthenticationViewModel(
    authenticationRepository: AuthenticationFirebaseRepository(
      dataSource: AuthenticationFirebaseDataSource()
    ),
        movsyRepository: MovsyGoRepositoryImpl(
      datasource: MovsyGoDatasourceImpl(
        client: MovsyHttpClient(
          urlBase: API.movsyBaseURL
        )
      )
    )
  )
  
  ContentView()
    .environment(authVm)
}
