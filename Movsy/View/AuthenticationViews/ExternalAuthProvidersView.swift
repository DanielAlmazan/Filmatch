//
//  ExternalAuthProvidersView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 20/10/24.
//

import AuthenticationServices
import SwiftUI

/// `ExternalAuthProvidersView` displays buttons for external authentication providers like Google and Apple.
/// It allows users to sign in using third-party services.
struct ExternalAuthProvidersView: View {
  /// Closure called when the Google Sign-In button is tapped.
  let onGoogleSignIn: (() -> Void)?

  /// Closure called when the Apple Sign-In button is tapped.
  let onAppleSignIn: (() -> Void)?

  let buttonsEnabled: Bool
  @State private var showAlert: Bool = false

  var body: some View {
    VStack {
      // MARK: - Separator
      HStack(spacing: 10) {
        Spacer()
          .frame(height: 1)
          .border(.gray, width: 1)
        Text("Or sign in with")
          .font(.headline)
          .foregroundStyle(.secondary)
        Spacer()
          .frame(height: 1)
          .border(.gray, width: 1)
      }

      // MARK: - Buttons
      HStack(alignment: .center, spacing: 10) {
        Group {
          // MARK: - Apple OAuth
          Button {
            if buttonsEnabled {
              onAppleSignIn?()
            } else {
              showAlert = true
            }
          } label: {
            Image(systemName: "apple.logo")
              .resizable()
              .scaledToFit()
              .frame(width: 48, height: 48)
              .tint(.bgBase)
          }
          .accessibilityLabel("Sign in with Apple")

          // MARK: - Google OAuth
          Button {
            if buttonsEnabled {
              onGoogleSignIn?()
            } else {
              showAlert = true
            }
          } label: {
            Image(.googleIcon)
              .resizable()
              .scaledToFit()
              .frame(width: 42, height: 42)
          }
          .accessibilityLabel("Sign in with Google")
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(width: 48, height: 48)
        .padding()
        .background(.onBgBase)
        .clipShape(.circle)
        .alert("Please, read and accept the Terms and Conditions to continue", isPresented: $showAlert) {
          // Leave default option
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var buttonsEnabled = true

  ExternalAuthProvidersView(onGoogleSignIn: nil, onAppleSignIn: nil, buttonsEnabled: buttonsEnabled)
}
