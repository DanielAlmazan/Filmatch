//
//  UsersListView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct UsersListView: View {
  @State var users: [OtterMatchUser]
  let onAction: (Binding<OtterMatchUser>, FriendshipAction) -> Void
  let onDelete: (OtterMatchUser) -> Void
  let onLastAppeared: () -> Void
  
  var body: some View {
    VStack {
      List {
        ForEach(users) { user in
          UserListRow(user: user, onAction: onAction, onDelete: onDelete, onLastAppeared: onLastAppeared)
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
  @Previewable @State var users: [OtterMatchUser] = [
    .default,
    .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil, friendshipStatus: .notRelated),
    .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil, friendshipStatus: .friend),
    .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil, friendshipStatus: .received)
  ]
  
  VStack {
    UsersListView(
      users: users,
      onAction: { user, action in print("Unblocked user") },
      onDelete: { user in print("Deleted user") }
    ) { print("Last item appeared") }
      .border(.onBgBase)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
