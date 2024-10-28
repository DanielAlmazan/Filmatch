//
//  ExternalAuthProvidersView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 20/10/24.
//

import SwiftUI

/// `ExternalAuthProvidersView` displays buttons for external authentication providers like Google and Apple.
/// It allows users to sign in using third-party services.
struct ExternalAuthProvidersView: View {
  /// Closure called when the Google Sign-In button is tapped.
  let onGoogleSignIn: (() -> Void)?
  
  /// Closure called when the Apple Sign-In button is tapped.
  let onAppleSignIn: (() -> Void)?
  
  /// State to control the display of the alert for unimplemented features.
  @State private var isAlertPresented: Bool = false
  
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
        // MARK: - Google OAuth
        Button {
          onGoogleSignIn?()
        } label: {
          Image(.googleIcon)
            .resizable()
            .scaledToFit()
            .frame(height: 48)
        }
        
        // MARK: - Apple OAuth
        Button {
          isAlertPresented = true
        } label: {
          Image(systemName: "apple.logo")
            .resizable()
            .scaledToFit()
            .frame(height: 48)
            .tint(.onBgBase)
        }.alert("Not implemented", isPresented: $isAlertPresented) {
        }
      }
    }

  }
}

#Preview {
  ExternalAuthProvidersView(onGoogleSignIn: nil, onAppleSignIn: nil)
}
