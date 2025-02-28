//
//  FriendRequestsView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 28/2/25.
//

import SwiftUI

struct FriendRequestsView: View {
  @State var users: [OtterMatchUser]
  let onAction: (Binding<OtterMatchUser>, FriendshipAction) -> Void
  let onDelete: (OtterMatchUser) -> Void
  let onLastAppeared: () -> Void

  @State private var isFolded: Bool = false

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text("Friend requests")
          .font(.title)

        Spacer()

        Button {
          isFolded.toggle()
        } label: {
          Image(systemName: isFolded ? "chevron.right" : "chevron.down")
            .foregroundColor(.secondary)
            .contentTransition(.symbolEffect(.replace))
        }
      }

      if !isFolded {
        UsersListView(
          users: users,
          onAction: onAction,
          onDelete: onDelete,
          onLastAppeared: onLastAppeared
        )
        .animation(.snappy, value: isFolded)
      }
    }
    .scrollClipDisabled()
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .border(.bgContainer.opacity(0.2))
    .overlay {
      RoundedRectangle(cornerRadius: 20)
        .stroke(.onBgBase.opacity(0.5), lineWidth: 2)
    }
    .cornerRadius(20)
    .animation(.bouncy, value: isFolded)
  }
}

#Preview{
  @Previewable @State var users: [OtterMatchUser] = [
    .default,
    .init(
      email: "test2@test.com", username: "test2", uid: "2", photoUrl: nil, friendshipStatus: .sent),
  ]

  VStack {
    FriendRequestsView(
      users: users,
      onAction: { user, action in print("User \(user.wrappedValue.username ?? "unknown") \(action)")
      },
      onDelete: { user in print("Deleted \(user.username ?? "unknown")") },
      onLastAppeared: { print("Last appeared") }
    )
    .padding()
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
}
