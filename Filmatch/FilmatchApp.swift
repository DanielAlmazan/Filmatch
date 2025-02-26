//
//  FilmatchApp.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/2/25.
//

import SwiftUI
import GoogleSignIn
import Firebase

@main
struct FilmatchApp: App {
  @AppStorage("isOnboarding") var isOnboarding: Bool = true
  @State var authVm: AuthenticationViewModel
  @State var otterMatchGoRepository: OtterMatchGoRepositoryImpl
  
  init() {
    let otterMatchGoRepository = OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(
        client: OtterMatchHttpClient(
          urlBase: API.otterMatchBaseURL
        )
      )
    )
    
    self.otterMatchGoRepository = otterMatchGoRepository
    
    FirebaseApp.configure()
    self.authVm = AuthenticationViewModel(
      authenticationRepository: AuthenticationFirebaseRepository(
        dataSource: AuthenticationFirebaseDataSource()
      ),
      otterMatchRepository: otterMatchGoRepository
    )
  }
  
  var body: some Scene {
    WindowGroup {
      if isOnboarding {
        OnBoardingView()
      } else {
        ContentView()
          .environment(authVm)
          .environment(otterMatchGoRepository)
          .onOpenURL { url in
            GIDSignIn.sharedInstance.handle(url)
          }
      }
    }
  }
}
