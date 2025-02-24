import SwiftUI

struct UserListRow: View {
  let user: FilmatchUser
  let onSendRequest: (FilmatchUser) -> Void
  let onAcceptRequest: (FilmatchUser) -> Void
  let onDeleteFriendship: (FilmatchUser) -> Void
  let onBlock: (FilmatchUser) -> Void
  let onUnblock: (FilmatchUser) -> Void
  
  var body: some View {
    HStack {
      UserAvatarView(username: user.username ?? "No username", size: 60)
      Text(user.username ?? "No username")
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
      
      getActionsView(for: user)
      
      Menu {
        if user.friendshipStatus == .blocked {
          Button("Unblock", role: .destructive) {
            onUnblock(user)
          }
        } else {
          Button("Block", role: .destructive) {
            onBlock(user)
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
  }
  
  @ViewBuilder
  private func getActionsView(for user: FilmatchUser) -> some View {
    switch user.friendshipStatus {
    case .notRelated:
      Button("Add") { onSendRequest(user) }
        .buttonStyle(.borderedProminent)
      
    case .sent:
      Button("Cancel Request") { onDeleteFriendship(user) }
        .buttonStyle(.bordered)
      
    case .received:
      HStack {
        Button("Accept") { onAcceptRequest(user) }
          .buttonStyle(.borderedProminent)
        Button("Reject") { onDeleteFriendship(user) }
          .buttonStyle(.bordered)
      }
      
    case .friend:
      Button("Remove Friend") { onDeleteFriendship(user) }
        .buttonStyle(.bordered)
      
    case .blocked:
      Button("Blocked") {} // Disabled, managed via the kebab menu
        .disabled(true)
        .buttonStyle(.bordered)
      
    case nil:
      EmptyView()
    }
  }
}

#Preview {
  VStack {
    UserListRow(
      user: .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil, friendshipStatus: .notRelated),
      onSendRequest: { user in print("Sent friend request") },
      onAcceptRequest: { user in print("Accepted request") },
      onDeleteFriendship: { user in print("Deleted friendship") },
      onBlock: { user in print("Blocked user") },
      onUnblock: { user in print("Unblocked user") }
    )
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
