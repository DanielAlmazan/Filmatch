//
//  AcceptDeclineRowButtons.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 17/9/24.
//

import SwiftUI

struct AcceptDeclineRowButtons: View {
  let item: (any DiscoverItem)
  let screenWidth: CGFloat
  let onAccept: ((any DiscoverItem)) -> Void
  let onSuperHype: ((any DiscoverItem)) -> Void
  let onWatched: ((any DiscoverItem)) -> Void
  let onDecline: ((any DiscoverItem)) -> Void
  
  var body: some View {
    HStack {
      Group {
        Button {
          onDecline(item)
        } label: {
          Image(.thumbDownButton)
            .resizable()
            .scaledToFit()
        }

        Button {
          onWatched(item)
        } label: {
          Image(.watchedIcon)
            .resizable()
            .scaledToFit()
        }

        Button {
          onSuperHype(item)
        } label: {
          Image(.superHypedIcon)
            .resizable()
            .scaledToFit()
        }

        Button {
          onAccept(item)
        } label: {
          Image(.thumbUpButton)
            .resizable()
            .scaledToFit()
        }
      }
      .padding()
    }
    .padding()
  }
}

#Preview {
  let item: DiscoverMovieItem = .default
  AcceptDeclineRowButtons(
    item: item,
    screenWidth: 480,
    onAccept: {item  in print ("Accepted \((item as! DiscoverMovieItem).title)") },
    onSuperHype: {item  in print ("SuperHyped \((item as! DiscoverMovieItem).title)") },
    onWatched: {item  in print ("Watched \((item as! DiscoverMovieItem).title)") },
    onDecline: { movie in print ("Declined \(item.title)")},
  )
}
