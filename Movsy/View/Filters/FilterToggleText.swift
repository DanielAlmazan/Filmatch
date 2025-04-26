//
//  FilterToggleText.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 22/4/25.
//

import SwiftUI

struct FilterToggleText: View {
  let text: String
  let localizedText: LocalizedStringKey?
  let size: CGFloat?

  init(text: String, size: CGFloat?) {
    self.text = text
    self.localizedText = nil
    self.size = size
  }

  init(localizedText: LocalizedStringKey, size: CGFloat?) {
    self.localizedText = localizedText
    text = ""
    self.size = size
  }

  var body: some View {
    if let size {
      Text(localizedText ?? LocalizedStringKey(text))
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .frame(width: size, height: size)
        .fontWeight(.semibold)
    } else {
      Text(localizedText ?? LocalizedStringKey(text))
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .fontWeight(.semibold)
    }
  }
}

#Preview {
  FilterToggleText(text: "All", size: nil)
  FilterToggleText(localizedText: "All", size: nil)
}
