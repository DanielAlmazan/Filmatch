//
//  UserGridItem.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct UserGridItem: View {
  let user: OtterMatchUser
  let size: CGFloat
  let onTap: () -> Void

  var body: some View {
    VStack {
      SimpleUserInfoView(user: user, size: size)
    }
    .frame(width: size, alignment: .leading)
    .padding()
    .background(.bgContainer)
    .clipShape(.rect(cornerRadius: 10))
    .shadow(radius: 5, y: 5)
    .onTapGesture { onTap() }
  }
}


#Preview {
  VStack {
    UserGridItem(user: .default, size: 100) { print("Item tapped")}
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
