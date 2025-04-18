//
//  WelcomeView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 6/10/24.
//

import SwiftUI

/// `AuthenticationSheetView` defines cases for the authentication sheet views (register and login).
enum AuthenticationSheetView: String, Identifiable {
  case REGISTER
  case LOGIN

  var id: String { rawValue }
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
        Spacer()

        // MARK: Logo, Title & Subtitle
        VStack(spacing: 16) {
          VStack {
            Image(.movsyLogo)
              .resizable()
              .scaledToFit()
              .frame(height: 150)
              .shadow(radius: 5, y: 4)

            Text("Welcome to Movsy!")
              .font(.title)
              .bold()
              .foregroundStyle(.white)

            GoToLoginButton(maxHeight: 100) {
              authVm.errorMessage = nil
              authenticationSheetView = .LOGIN
            }
          }

          if let errorMessage = authVm.errorMessage, !errorMessage.isEmpty {
            Text(errorMessage)
              .foregroundColor(.red)
          }

          if let user = authVm.currentUser, user.isNotVerified, authVm.currentUser?.isEmailVerified == false {
            VStack {
              Text("We’ve sent a verification link to \(user.maskedEmail ?? "your email").")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(.white)

              Button("Resend Verification Email") {
                authVm.sendEmailVerification()
              }
              .buttonStyle(.borderedProminent)
            }
          }
        }

        Spacer()

        VStack {
          Text("Powered by")
            .font(.caption)
            .foregroundStyle(.white)
          Image(.tmdbAttributionLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 100)
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
    .task {
      await authVm.refreshEmailVerificationStatus()
    }
  }
}

#Preview {
  @Previewable @State var authenticationViewModel = AuthenticationViewModel(
    authenticationRepository: AuthenticationFirebaseRepository(
      dataSource: AuthenticationFirebaseDataSource()
    ),
        movsyRepository: MovsyGoRepositoryImpl(
      datasource: MovsyGoDatasourceImpl(
        client: MovsyHttpClient(
          urlBase: API.movsyBaseURL)
      )
    )
  )

  WelcomeView()
    .environment(authenticationViewModel)
    .task { authenticationViewModel.currentUser = .default }
}
