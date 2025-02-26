//
//  ExternalAuthProvidersView.swift
//  OtterMatch
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
            onAppleSignIn?()
          } label: {
            Image(systemName: "apple.logo")
              .resizable()
              .scaledToFit()
              .frame(width: 48, height: 48)
              .tint(.bgBase)
          }

          // MARK: - Google OAuth
          Button {
            onGoogleSignIn?()
          } label: {
            Image(.googleIcon)
              .resizable()
              .scaledToFit()
              .frame(width: 42, height: 42)
          }
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(width: 48, height: 48)
        .padding()
        .background(.onBgBase)
        .clipShape(.circle)
      }
    }
  }
}

#Preview {
  ExternalAuthProvidersView(onGoogleSignIn: nil, onAppleSignIn: nil)
}
