//
//  SimpleUserInfoView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct SimpleUserInfoView: View {
  let user: FilmatchUser
  let size: CGFloat

  var body: some View {
    if let username = user.username, !username.isEmpty {
      VStack {
        UserAvatarView(username: username, size: size)
          .shadow(radius: 5, y: 5)
        Text(username)
          .bold()
          .font(.headline)
      }
      .frame(width: size)
      .lineLimit(1)
    }
  }
}

#Preview {
  VStack {
    SimpleUserInfoView(user: .default, size: 100)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
}
