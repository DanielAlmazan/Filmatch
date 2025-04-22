//
//  UsersListView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct UsersListView: View {
  var users: [MovsyUser]
  let onAction: (Binding<MovsyUser>, FriendshipAction) -> Void
  let onLastAppeared: () -> Void
  
  var body: some View {
    VStack {
      List {
        ForEach(users) { user in
          UserListRow(
            user: user,
            onAction: onAction)
          .onAppear {
            if users.last == user {
              onLastAppeared()
            }
          }
          .listRowSeparator(.hidden)
          .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 11, trailing: 0))
        }
        .listRowBackground(Color.clear)
      }
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
    }
  }
}

#Preview {
  @Previewable @State var users: [MovsyUser] = [
    .default,
    .init(
      email: nil,
      username: "miirii",
      uid: "FirebaseUID1",
      photoUrl: nil,
      friendshipStatus: .notRelated,
      isEmailVerified: nil,
    ),
    .init(
      email: nil,
      username: "fake_miirii",
      uid: "FirebaseUID2",
      photoUrl: nil,
      friendshipStatus: .friend,
      isEmailVerified: nil,
    ),
    .init(
      email: nil,
      username: "miiraculous_one",
      uid: "FirebaseUID",
      photoUrl: nil,
      friendshipStatus: .received,
      isEmailVerified: nil,
    )
  ]
  
  VStack {
    UsersListView(
      users: users,
      onAction: { user, action in print("Unblocked user") }
    ) { print("Last item appeared") }
      .border(.onBgBase)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
