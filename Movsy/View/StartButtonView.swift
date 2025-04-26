//
//  StartButtonView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 3/10/24.
//

import SwiftUI

struct StartButtonView: View {
  let isLastPage: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      HStack(spacing: 8) {
        Text(isLastPage ? "Start" : "Next")

        Image(systemName: isLastPage ? "arrow.right.circle" : "forward.fill")
          .imageScale(.large)
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
    }
    .buttonStyle(.borderedProminent)
  }
}

#Preview {
  VStack(spacing: 20) {
    StartButtonView(isLastPage: true) {
      print("Button pressed")
    }
    StartButtonView(isLastPage: false) {
      print("Button pressed")
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Gradient(colors: [.accent, .accentDarker]))
}
