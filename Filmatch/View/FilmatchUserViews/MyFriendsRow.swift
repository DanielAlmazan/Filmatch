//
//  MyFriendsRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct MyFriendsRow<Content: View>: View {
  let friends: [FilmatchUser]
  let content: (FilmatchUser) -> Content
  
  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 10) {
        ForEach(friends) { friend in
          content(friend)
        }
      }
    }
  }
}

#Preview {
  VStack {
    MyFriendsRow(
      friends: [
        .default,
        .init(email: nil, username: "miirii", uid: "FirebaseUID1"),
        .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2"),
        .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID")
      ]
    ) { friend in
      UserGridItem(user: friend, size: 100)
    }
    
    MyFriendsRow(
      friends: [
        .default,
        .init(email: nil, username: "miirii", uid: "FirebaseUID1"),
        .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2"),
        .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID")
      ]
    ) { friend in
      SimpleUserInfoView(user: friend, size: 100)
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
