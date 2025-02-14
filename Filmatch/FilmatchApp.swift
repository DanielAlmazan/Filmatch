//
//  FilmatchApp.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Firebase
import GoogleSignIn
import SwiftUI

@main
struct FilmatchApp: App {
  @AppStorage("isOnboarding") var isOnboarding: Bool = true
  @State var authVm: AuthenticationViewModel
  @State var filmatchGoRepository: FilmatchGoRepositoryImpl

  init() {
    let filmatchGoRepository = FilmatchGoRepositoryImpl(
      datasource: FilmatchGoDatasourceImpl(
        client: FilmatchHttpClient(
          urlBase: AppConstants.filmatchBaseUrl
        )
      )
    )
    
    self.filmatchGoRepository = filmatchGoRepository
    
    FirebaseApp.configure()
    self.authVm = AuthenticationViewModel(
      authenticationRepository: AuthenticationFirebaseRepository(
        dataSource: AuthenticationFirebaseDataSource()
      ),
      filmatchRepository: filmatchGoRepository
    )
  }

  var body: some Scene {
    WindowGroup {
      if isOnboarding {
        OnBoardingView()
      } else {
        ContentView()
          .environment(authVm)
          .environment(filmatchGoRepository)
          .onOpenURL { url in
            GIDSignIn.sharedInstance.handle(url)
          }
      }
    }
  }
}
