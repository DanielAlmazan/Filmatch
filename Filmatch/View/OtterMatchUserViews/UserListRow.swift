import SwiftUI

struct UserListRow: View {
  @State var user: OtterMatchUser
  let onAction: (Binding<OtterMatchUser>, FriendshipAction) -> Void
  let onDelete: (OtterMatchUser) -> Void
  let onLastAppeared: () -> Void
  
  var body: some View {
    HStack {
      UserAvatarView(user: user, size: 60)
      Text(user.username ?? "No username")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      FriendshipActionProvider.getActionsView(for: $user, onAction: onAction, onDelete: onDelete)
      .lineLimit(1)
      
      Menu {
        if user.friendshipStatus == .blocked {
          Button("Unblock", role: .destructive) {
            onAction($user, .unblock)
          }
        } else {
          Button("Block", role: .destructive) {
            onAction($user, .block)
          }
        }
      } label: {
        Image(systemName: "ellipsis")
          .rotationEffect(.degrees(90))
          .padding(.horizontal, 8)
      }
    }
    .padding()
    .background(.bgContainer)
    .clipShape(.rect(cornerRadius: 10))
    .shadow(radius: 5, y: 5)
    .onAppear(perform: onLastAppeared)
  }
}

#Preview {
  VStack {
    UserListRow(
      user: .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil, friendshipStatus: .notRelated),
      onAction: { user, action in print("Sent friend request") },
      onDelete: { user in print("Deleted") },
      onLastAppeared: { print("Last appeared") }
    )
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
