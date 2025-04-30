//
//  FriendRequestsView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 28/2/25.
//

import SwiftUI

struct FriendRequestsView: View {
  var users: [MovsyUser]
  let onAction: (MovsyUser, FriendshipAction) -> Void
  let onLastAppeared: () -> Void

  @State private var isFriendshipRequestsExpanded: Bool = true

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Friendship Requests")
          .font(.title2)
          .fontWeight(.semibold)
        Spacer()
        Button {
          withAnimation(.bouncy(duration: 0.3)) {
            isFriendshipRequestsExpanded.toggle()
          }
        } label: {
          Image(systemName: isFriendshipRequestsExpanded ? "chevron.down" : "chevron.right")
            .symbolEffect(.bounce, value: isFriendshipRequestsExpanded)
        }
      }
      if isFriendshipRequestsExpanded {
        ForEach(users) { user in
          UserListRow(
            user: user,
            onAction: onAction
          )
          .onAppear {
            if users.last == user {
              onLastAppeared()
            }
          }
        }
      }
    }
  }
}

#Preview{
  @Previewable @State var users: [MovsyUser] = [
    .default,
    .init(
      email: "test2@test.com",
      username: "test2",
      uid: "2",
      photoUrl: nil,
      friendshipStatus: .sent,
      isEmailVerified: nil,
    ),
  ]
  @Previewable @State var isExpanded: Bool = false

  List {
    FriendRequestsView(
      users: users,
      onAction: { user, action in print("User \(user.username ?? "unknown") \(action)") },
      onLastAppeared: { print("Last appeared") }
    )
  }
  .listStyle(.sidebar)
  .background(.bgBase)
}
