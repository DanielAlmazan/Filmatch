import SwiftUI

struct UserListRow: View {
  var user: MovsyUser
  let onAction: (MovsyUser, FriendshipAction) -> Void
  
  let kSize: CGFloat = 60
  
  var body: some View {
    HStack {
      VStack(alignment: .center) {
        UserAvatarView(user: user, size: kSize)
        Text(user.username ?? "No username")
          .font(.caption)
          .lineLimit(1)
      }
      .frame(maxWidth: kSize, alignment: .leading)
      
      Spacer()
      
      FriendshipActionProvider.getActionsView(for: user, onAction: onAction)
      .lineLimit(1)
      
      Menu {
        if user.friendshipStatus == .blocked {
          Button("Unblock", role: .destructive) {
            onAction(user, .unblock)
          }
        } else {
          Button("Block", role: .destructive) {
            onAction(user, .block)
          }
        }
      } label: {
        Image(systemName: "ellipsis")
          .rotationEffect(.degrees(90))
          .frame(width: 30, height: 30)
      }
    }
    .padding()
    .background(.bgContainer)
    .clipShape(.rect(cornerRadius: 10))
    .shadow(radius: 5, y: 5)
  }
}

#Preview {
  VStack {
    UserListRow(
      user: .default,
      onAction: { user, action in print("Sent friend request") }
    )
    UserListRow(
      user: .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil, friendshipStatus: .notRelated, isEmailVerified: nil,),
      onAction: { user, action in print("Sent friend request") }
    )
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
