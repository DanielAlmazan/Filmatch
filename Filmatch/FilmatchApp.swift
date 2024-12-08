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
  var authVm: AuthenticationViewModel

  init() {
    FirebaseApp.configure()
    authVm = .init()
  }

  var body: some Scene {
    WindowGroup {
      if isOnboarding {
        OnBoardingView()
      } else {
        ContentView(authVm: authVm)
          .onOpenURL { url in
            GIDSignIn.sharedInstance.handle(url)
          }
      }
    }
  }
}
