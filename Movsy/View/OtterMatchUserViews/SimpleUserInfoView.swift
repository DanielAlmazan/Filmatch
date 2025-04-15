//
//  SimpleUserInfoView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct SimpleUserInfoView: View {
  let user: MovsyUser
  let size: CGFloat

  var body: some View {
    VStack {
      UserAvatarView(user: user, size: size)
        .shadow(radius: 5, y: 5)
      Text(user.username ?? "No username")
        .bold()
        .font(.headline)
    }
    .frame(width: size)
    .lineLimit(1)
  }
}

#Preview {
  VStack {
    SimpleUserInfoView(user: .default, size: 100)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
}
