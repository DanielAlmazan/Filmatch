//
//  SearchUsersGridView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct SearchUsersGridView: View {
  let columns: [GridItem]
  let users: [FilmatchUser]
  
  let onLastAppeared: () -> Void

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 16) {
        ForEach(users) { user in
          UserGridItem(user: user, size: 85, areFriends: false)
            .onAppear {
              if users.last == user {
                self.onLastAppeared()
              }
            }
        }
      }
    }
  }
}

#Preview {
  @Previewable @State var users: [FilmatchUser] = [
      .default,
      .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil),
      .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil),
      .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil)
    ]

  SearchUsersGridView(
    columns: [
      GridItem(.flexible(), spacing: 16),
      GridItem(.flexible(), spacing: 16),
      GridItem(.flexible(), spacing: 16),
    ],
    users: users
  ) { print("Last user appeared") }
}
