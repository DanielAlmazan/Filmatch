//
//  FriendRequestsView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 28/2/25.
//

import SwiftUI

struct FriendRequestsView: View {
  @State var users: [MovsyUser]
  let onAction: (Binding<MovsyUser>, FriendshipAction) -> Void
  let onLastAppeared: () -> Void

  @State private var isFolded: Bool = true

  var body: some View {
    VStack {
      Section(isExpanded: $isFolded, content: {
        ForEach(users) { user in
          UserListRow(
            user: user,
            onAction: onAction
          )
          .listRowSeparator(.hidden)
        }
        .listRowBackground(Color.clear)
      }, header: {
        Text("Friendship Requests")
          .font(.title2)
          .fontWeight(.semibold)
      })
    }
    .padding()
    .overlay {
      RoundedRectangle(cornerRadius: 10)
        .stroke(.onBgBase.opacity(0.5), lineWidth: 2)
    }
  }
}

#Preview{
  @Previewable @State var users: [MovsyUser] = [
    .default,
    .init(
      email: "test2@test.com", username: "test2", uid: "2", photoUrl: nil, friendshipStatus: .sent),
  ]
  @Previewable @State var isExpanded: Bool = false

  List {
    FriendRequestsView(
      users: users,
      onAction: { user, action in print("User \(user.wrappedValue.username ?? "unknown") \(action)") },
      onLastAppeared: { print("Last appeared") }
    )
  }
  .listStyle(.sidebar)
  .background(.bgBase)
}
