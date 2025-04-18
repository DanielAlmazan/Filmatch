//
//  MatchesRowView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import SwiftUI

struct MatchesRowView: View {
  let matches: [Match]
  let cornerRadius: CGFloat

  @State private var isPresentingLists: Bool = false

  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(matches.prefix(10), id: \.id) { match in
          VStack(alignment: .leading) {
            MatchView(match: match)
              .onLongPressGesture {
                // TODO: Apply item list crud
              }
          }
          .lineLimit(1)
        }
      }
    }
    .scrollClipDisabled()
  }
}

#Preview {
  MatchesRowView(matches: [.movieMock], cornerRadius: 10)
    .frame(maxHeight: 150)
}
