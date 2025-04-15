//
//  MovsyApp.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 14/4/25.
//

import SwiftUI
import GoogleSignIn
import Firebase

@main
struct MovsyApp: App {
  @AppStorage("isOnboarding") var isOnboarding: Bool = true
  @State var authVm: AuthenticationViewModel
  @State var movsyGoRepository: MovsyGoRepositoryImpl

  init() {
    let movsyGoRepository = MovsyGoRepositoryImpl(
      datasource: MovsyGoDatasourceImpl(
        client: MovsyHttpClient(
          urlBase: API.movsyBaseURL
        )
      )
    )

    self.movsyGoRepository = movsyGoRepository

    FirebaseApp.configure()
    self.authVm = AuthenticationViewModel(
      authenticationRepository: AuthenticationFirebaseRepository(
        dataSource: AuthenticationFirebaseDataSource()
      ),
          movsyRepository: movsyGoRepository
    )
  }

  var body: some Scene {
    WindowGroup {
      if isOnboarding {
        OnBoardingView()
      } else {
        ContentView()
          .environment(authVm)
          .environment(movsyGoRepository)
          .onOpenURL { url in
            GIDSignIn.sharedInstance.handle(url)
          }
      }
    }
  }
}
