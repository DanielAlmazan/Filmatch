//
//  OtterMatchApp.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Firebase
import GoogleSignIn
import SwiftUI

@main
struct OtterMatchApp: App {
  @AppStorage("isOnboarding") var isOnboarding: Bool = true
  @State var authVm: AuthenticationViewModel
  @State var otterMatchGoRepository: OtterMatchGoRepositoryImpl

  init() {
    let otterMatchGoRepository = OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(
        client: OtterMatchHttpClient(
          urlBase: AppConstants.otterMatchBaseUrl
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
