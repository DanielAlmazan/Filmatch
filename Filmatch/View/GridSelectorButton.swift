//
//  GridSelectorButton.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct GridSelectorButton: View {
  @Binding var isGridSelected: Bool

  var body: some View {
    Button {
      isGridSelected.toggle()
    } label: {
      Image(systemName: isGridSelected ? "square.grid.2x2.fill" : "list.bullet")
    }
    .frame(width: 24, height: 24)
    .symbolEffect(.bounce, options: .nonRepeating, value: isGridSelected)
  }
}

#Preview {
  @Previewable @State var isGridSelected = true
  GridSelectorButton(isGridSelected: $isGridSelected)
}
