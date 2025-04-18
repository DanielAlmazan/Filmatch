//
//  InterestStatusPicker.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 7/4/25.
//

import SwiftUI

struct InterestStatusPicker: View {
  @Binding var selection: InterestStatus?
  var statuses: [InterestStatus] = InterestStatus.allCases.filter { $0 != .pending }

  var body: some View {
    Picker("", selection: $selection) {
      ForEach(statuses) { status in
        if let icon = status.icon {
          icon.tag(status)
        }
      }
    }
    .pickerStyle(.palette)
  }
}

#Preview {
  @Previewable @State var selection: InterestStatus? = .watchlist
  InterestStatusPicker(selection: $selection)
}
