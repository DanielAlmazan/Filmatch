//
//  UserGridItem.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct UserGridItem: View {
  let user: FilmatchUser
  let size: CGFloat
  let areFriends: Bool

  var body: some View {
    VStack {
      SimpleUserInfoView(user: user, size: size)
    }
    .frame(width: size, alignment: .leading)
    .padding()
    .background(.bgContainer)
    .clipShape(.rect(cornerRadius: 10))
    .shadow(radius: 5, y: 5)
  }
}

#Preview {
  VStack {
    UserGridItem(user: .default, size: 100, areFriends: true)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
