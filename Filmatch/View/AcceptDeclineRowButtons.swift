//
//  AcceptDeclineRowButtons.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/9/24.
//

import SwiftUI

struct AcceptDeclineRowButtons: View {
  let item: (any DiscoverItem)
  let screenWidth: CGFloat
  let onAccept: ((any DiscoverItem), CGFloat) -> Void
  let onDecline: ((any DiscoverItem), CGFloat) -> Void
  
  var body: some View {
    HStack {
      Button {
        onDecline(item, screenWidth)
      } label: {
        Image(.thumbDownButton)
          .resizable()
          .scaledToFit()
          .frame(width: 100)
      }

      Spacer()

      Button {
        onAccept(item, screenWidth)
      } label: {
        Image(.thumbUpButton)
          .resizable()
          .scaledToFit()
          .frame(width: 100)
      }
    }
    .padding()
  }
}

#Preview {
  let item: DiscoverMovieItem = .default
  AcceptDeclineRowButtons(item: item, screenWidth: 480, onAccept: {item, width  in print ("Accepted \((item as! DiscoverMovieItem).title)") }, onDecline: { movie, width in print ("Declined \(item.title)")})
}
