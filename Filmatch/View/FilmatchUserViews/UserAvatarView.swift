//
//  UserAvatarView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct UserAvatarView: View {
  let username: String
  let size: CGFloat
  
  init(username: String?, size: CGFloat) {
    self.username = username ?? "?"
    self.size = size
  }
  
  var body: some View {
    Text(username.prefix(1).uppercased())
      .font(.title)
      .frame(width: size, height: size)
      .background(
        RadialGradient(
          gradient: Gradient(colors: [.accent, .accentDarker]),
          center: .center,
          startRadius: 10,
          endRadius: 50
        )
      )
      .clipShape(Circle())
  }
}

#Preview {
  VStack {
    UserAvatarView(username: "gas_esnake", size: 100)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
}
