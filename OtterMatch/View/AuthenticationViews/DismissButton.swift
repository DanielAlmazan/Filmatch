//
//  DismissButton.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

import SwiftUI

/// `DismissButton` provides a button to dismiss the current view.
/// It is typically used in modal views or sheets.
struct DismissButton: View {
  @Environment(\.dismiss) var dismiss

  var body: some View {
    HStack {
      Spacer()
      Button("Dismiss") {
        dismiss()
      }
      .padding()
      .buttonStyle(.bordered)
    }
  }
}

#Preview {
  DismissButton()
}
