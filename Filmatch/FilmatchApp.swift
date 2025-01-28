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

  init() {
    FirebaseApp.configure()
    authVm = AuthenticationViewModel(
      authenticationRepository: AuthenticationFirebaseRepository(
        dataSource: AuthenticationFirebaseDataSource()
      ),
      filmatchClient: FilmatchGoRepositoryImpl(
        datasource: FilmatchGoDatasourceImpl(
          client: FilmatchHttpClient(
            urlBase: AppConstants.filmatchBaseUrl)
        )
      )
    )
  }

  var body: some Scene {
    WindowGroup {
      if isOnboarding {
        OnBoardingView()
      } else {
        ContentView()
          .environment(authVm)
          .onOpenURL { url in
            GIDSignIn.sharedInstance.handle(url)
          }
      }
    }
  }
}
