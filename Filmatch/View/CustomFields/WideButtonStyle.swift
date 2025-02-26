//
//  WideButtonStyle.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/10/24.
//

import SwiftUI

/// `WideButtonStyle` is a custom button style that provides a wide, full-width button appearance.
/// It adjusts its appearance based on the button's state (pressed, enabled).
struct WideButtonStyle: ButtonStyle {
  @Environment(\.isEnabled) private var isEnabled: Bool
  
  func makeBody(configuration: Configuration) -> some View {
    var buttonBackground: Color {
      configuration.isPressed
        ? .accentDarker
        : isEnabled
          ? .accent
          : .accent.opacity(0.3)
    }
    
    withAnimation {
      configuration.label
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .foregroundStyle(isEnabled ? .onBgBase : .onBgBase.opacity(0.3))
        .background(buttonBackground)
        .clipShape(.capsule)
        .padding(.horizontal)
    }
  }
}
