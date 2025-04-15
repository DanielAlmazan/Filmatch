//
//  SearchUsersGridView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct SearchUsersGridView: View {
  let columns: [GridItem]
  let users: [MovsyUser]
  let onItemTap: (MovsyUser) -> Void
  
  let onLastAppeared: () -> Void

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns, spacing: 16) {
        ForEach(users) { user in
          UserGridItem(user: user, size: 85) {
            onItemTap(user)
          }
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
  @Previewable @State var users: [MovsyUser] = [
      .default,
      .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil, friendshipStatus: .notRelated),
      .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil, friendshipStatus: .friend),
      .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil, friendshipStatus: .received)
    ]

  SearchUsersGridView(
    columns: [
      GridItem(.flexible(), spacing: 16),
      GridItem(.flexible(), spacing: 16),
      GridItem(.flexible(), spacing: 16),
    ],
    users: users
  ) { user in
    print("Tapped: \(user)")
  } onLastAppeared: {
    print("Last user appeared")
  }
}
