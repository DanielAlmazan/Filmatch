//
//  WelcomeView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/10/24.
//

import SwiftUI

/// `AuthenticationSheetView` defines cases for the authentication sheet views (register and login).
enum AuthenticationSheetView: String, Identifiable {
  case REGISTER
  case LOGIN

  var id: String {
    return rawValue
  }
}


/// `WelcomeView` is the initial screen shown to users, offering options to go to Rooms or log in.
struct WelcomeView: View {
  /// Manages the authentication view model and sheet presentation state.
  @Environment(AuthenticationViewModel.self) var authVm

  /// Represents which view is active on the sheet.
  @State var authenticationSheetView: AuthenticationSheetView?

  var body: some View {
    NavigationStack {
      VStack(spacing: 25) {
        // MARK: Logo, Title & Subtitle
        VStack {
          Image(.filmatchLogo)
            .resizable()
            .scaledToFit()
            .frame(height: 150)
            .shadow(radius: 5, y: 4)

          Text("Welcome to Filmatch!")
            .font(.title)
            .bold()

          Text("How do you want to start your adventure?")
            .font(.subheadline)
        }
        .foregroundStyle(.white)

        VStack {
          // MARK: Go to Rooms Button
          NavigationLink(destination: RoomsMainView()) {
            GoToRoomsButton(iconMaxWidth: 65)
          }

          // MARK: Log in
          GoToLoginButton(maxHeight: 100) {
            authenticationSheetView = .LOGIN
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .padding()
      .background(Gradient(colors: [.accent, .accentDarker]))
      .sheet(
        item: $authenticationSheetView,
        onDismiss: { authVm.errorMessage = nil }
      ) { sheet in
        switch sheet {
          case .LOGIN:
            LoginView(authVm: authVm, authSheetView: $authenticationSheetView)
              .presentationDetents(.init([.fraction(0.75)]))
          case .REGISTER:
            RegisterView(authVm: authVm, authSheetView: $authenticationSheetView)
              .presentationDetents(.init([.fraction(0.75)]))
        }
      }
    }
  }
}

#Preview {
  WelcomeView()
}
