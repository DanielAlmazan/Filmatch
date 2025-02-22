//
//  UserListRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct UserListRow: View {
  let user: FilmatchUser
  let areFriends: Bool
  
  var body: some View {
    HStack {
      UserAvatarView(username: user.username ?? "No username", size: 60)
      
      Text(user.username ?? "No username")
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(.bgContainer)
    .clipShape(.rect(cornerRadius: 10))
    .shadow(radius: 5, y: 5)
  }
}

#Preview {
  VStack {
    UserListRow(user: .default, areFriends: true)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
