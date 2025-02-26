//
//  DismissSheetButton.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 16/12/24.
//

import SwiftUI

struct DismissSheetButton: View {
  @Environment(\.dismiss) var dismiss
  
  let onDismissSheet: (() -> Void)?
  
  var body: some View {
    Button {
      onDismissSheet?()
      dismiss()
    } label: {
      Image(systemName: "xmark.circle.fill")
        .font(.title)
        .background(.onAccent)
        .clipShape(Circle())
        .shadow(radius: 10)
    }
    .padding(15)
  }
}

#Preview {
  VStack(alignment: .trailing) {
    DismissSheetButton() {
      print("Dismissed")
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
  .padding(16)
  .background(Gradient(colors: [.accent, .accentDarker]))
}
