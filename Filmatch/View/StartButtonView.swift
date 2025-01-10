//
//  StartButtonView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 3/10/24.
//

import SwiftUI

struct StartButtonView: View {
  @AppStorage("isOnboarding") var isOnboarding: Bool?

  var body: some View {
    Button(action: { isOnboarding = false }) {
      HStack(spacing: 8) {
        Text("Start")

        Image(systemName: "arrow.right.circle")
          .imageScale(.large)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(Capsule().strokeBorder(.black, lineWidth: 1.25))
    }
    .accentColor(.black)
  }
}

#Preview {
  VStack {
    StartButtonView()
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Gradient(colors: [.accent, .accentDarker]))
}
