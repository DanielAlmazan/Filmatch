//
//  MediaSelector.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import SwiftUI

struct MediaSelector: View {
  @Binding var selectedMedia: MediaType
  var body: some View {
    HStack(spacing: 20) {
      FilterToggleView(
        text: "Movie", isActive: selectedMedia == .movie
      ) {
        selectedMedia = .movie
      }
      
      FilterToggleView(
        text: "TV Series", isActive: selectedMedia == .tvSeries
      ) {
        selectedMedia = .tvSeries
      }
    }
    .buttonStyle(.borderless)
    .containerRelativeFrame(.horizontal)  // Movies / TV Selector
  }
}

#Preview {
  @Previewable @State var selectedMedia: MediaType = .movie
  MediaSelector(selectedMedia: $selectedMedia)
}
