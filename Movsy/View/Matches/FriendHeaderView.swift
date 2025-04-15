//
//  FriendHeaderView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import SwiftUI

struct FriendHeaderView: View {
  let user: MovsyUser

  var body: some View {
    HStack {
      UserAvatarView(user: user, size: 36)
        .font(.caption2)
      Text(user.username ?? "No username")
        .font(.headline)
    }
  }
}

#Preview {
  FriendHeaderView(user: .default)
}
