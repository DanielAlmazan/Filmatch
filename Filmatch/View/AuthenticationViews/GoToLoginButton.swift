//
//  GoToLoginButton.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 13/10/24.
//

import SwiftUI

/// `GoToLoginButton` is a custom button that navigates users to the login screen.
/// It displays promotional content encouraging users to log in for full app access.
struct GoToLoginButton: View {
  /// The maximum height of the button, used for layout calculations.
  let maxHeight: CGFloat
  
  /// Closure called when the button is tapped.
  let onButtonTap: () -> Void

  var body: some View {
      Button {
        onButtonTap()
      } label: {
        HStack {
          VStack(spacing: 10) {
            VStack {
              Text("Log in")
                .font(.title3)
                .bold()
              Text("(Full app!)")
                .font(.subheadline)
            }

            Text("Log in to access to all the app’s functionalities!")
              .font(.caption2)
          }
          .padding(.horizontal, maxHeight / 2)
          .padding(.vertical)
          .frame(maxWidth: .infinity)
          .overlay {
            // MARK: - Decorative icons overlay
            ZStack {
              Image(systemName: "heart.fill")
                .resizable()
                .scaledToFit()
                .rotationEffect(Angle(degrees: 25))
                .frame(width: maxHeight / 3)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(x: maxHeight * 0.1, y: maxHeight * 0.12)
                .tint(.red)
              
              Image(systemName: "bookmark.fill")
                .resizable()
                .scaledToFit()
                .offset(x: maxHeight * 0.7)
                .frame(maxHeight: maxHeight * 0.4)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .tint(.yellow)
              
              Image(.filmatchLogoMonotone)
                .resizable()
                .scaledToFit()
                .rotationEffect(Angle(degrees: -20))
                .frame(maxHeight: maxHeight * 0.6)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(x: maxHeight * 0.05, y: maxHeight * 0.1)
            }
            .opacity(0.3)
          }
        }
        .tint(.accentDarker)
        .background(.white.opacity(0.8))
        .clipShape(.rect(cornerRadius: 20))
      }
  }
}

#Preview {
  VStack {
    GoToLoginButton(maxHeight: 100) { print("Go to login button tapped!") }
  }
  .padding()
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Gradient(colors: [.accent, .accentDarker]))
}
