//
//  GoToRoomsButton.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 15/10/24.
//

import SwiftUI

/// `GoToRoomsButton` navigates users to the Rooms feature without requiring login.
struct GoToRoomsButton: View {
  
  /// Controls the maximum width of the icon.
  let iconMaxWidth: CGFloat

  var body: some View {
    HStack {
      VStack(spacing: 10) {
        VStack {
          Text("Go to Rooms")
            .font(.title3)
            .bold()
          Text("(Without login!)")
            .font(.subheadline)
        }
        .tint(.green)

        Text("Choose films with your friends without logging in!")
          .font(.caption2)
      }
      .frame(maxWidth: .infinity)
      
      Image(.filmatchLogoMonotone)
        .resizable()
        .scaledToFit()
        .frame(maxWidth: iconMaxWidth)
    }
    .foregroundStyle(.white)
    .multilineTextAlignment(.center)
    .padding()
    .background(.black.opacity(0.6))
    .clipShape(.rect(cornerRadius: 20))
  }
}

// Disclaimer: This preview modifies the original component in order to
// provide a more comfortable view while building it
#Preview {
  VStack {
    GoToRoomsButton(iconMaxWidth: 65)
      .offset(y: 63)
  }
  .padding()
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Gradient(colors: [.accent, .accentDarker]))
}
