//
//  SearchUsersListView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct SearchUsersListView: View {
  let users: [FilmatchUser]
  let onSendRequest: (FilmatchUser) -> Void
  let onAcceptRequest: (FilmatchUser) -> Void
  let onDeleteFriendship: (FilmatchUser) -> Void
  let onBlock: (FilmatchUser) -> Void
  let onUnblock: (FilmatchUser) -> Void

  let onLastAppeared: () -> Void
  
  var body: some View {
    VStack {
      List {
        ForEach(users) { user in
          UserListRow(user: user, onSendRequest: onSendRequest, onAcceptRequest: onAcceptRequest, onDeleteFriendship: onDeleteFriendship, onBlock: onBlock, onUnblock: onUnblock)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 11, leading: 0, bottom: 11, trailing: 0))
        }
        .listRowBackground(Color.clear)
      }
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
      
    }
  }
}

#Preview {
  VStack {
    SearchUsersListView(
      users: [
        .default,
        .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil, friendshipStatus: .notRelated),
        .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil, friendshipStatus: .friend),
        .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil, friendshipStatus: .received)
      ],
      onSendRequest: { user in print("Sent friend request") },
      onAcceptRequest: { user in print("Accepted request") },
      onDeleteFriendship: { user in print("Deleted friendship") },
      onBlock: { user in print("Blocked user") },
      onUnblock: { user in print("Unblocked user") }
    ) { print("Last item appeared") }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
