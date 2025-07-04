//
//  FriendshipActionProvider.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 24/2/25.
//

import SwiftUI

enum FriendshipAction {
  case sendRequest
  case cancelRequest
  case acceptRequest
  case rejectRequest
  case deleteFriend
  case block
  case unblock
  
  var isDestructive: Bool {
    self == .cancelRequest ||
    self == .acceptRequest ||
    self == .rejectRequest ||
    self == .deleteFriend ||
    self == .block
  }
}

struct FriendshipActionProvider {
  static func getActionSheet(
    for user: MovsyUser,
    onAction: @escaping (MovsyUser, FriendshipAction) -> Void
  ) -> ActionSheet {

    let actions: [ActionSheet.Button] = {
      switch user.friendshipStatus {
      case .notRelated:
        return [
          .default(Text("Send friend request")) {
            onAction(user, .sendRequest)
          },
          .destructive(Text("Block")) {
            onAction(user, .block)
          },
          .cancel(),
        ]
      case .sent:
        return [
          .default(Text("Cancel friend request")) {
            onAction(user, .cancelRequest)
          },
          .destructive(Text("Block")) {
            onAction(user, .block)
          },
          .cancel(),
        ]
      case .received:
        return [
          .default(Text("Accept")) {
            onAction(user, .acceptRequest)
          },
          .default(Text("Reject")) {
            onAction(user, .rejectRequest)
          },
          .destructive(Text("Block")) {
            onAction(user, .block)
          },
          .cancel(),
        ]
      case .friend:
        return [
          .default(Text("Delete friend")) {
            onAction(user, .deleteFriend)
          },
          .destructive(Text("Block")) {
            onAction(user, .block)
          },
          .cancel(),
        ]
      case .blocked:
        return [
          .default(Text("Unblock")) {
            onAction(user, .unblock)
          },
          .cancel(),
        ]
      case nil:
        return [.cancel()]
      }
    }()

    return ActionSheet(title: Text(user.username ?? "User"), buttons: actions)
  }

  @MainActor
  @ViewBuilder
  static func getActionsView(
    for user: MovsyUser,
    onAction: @escaping (MovsyUser, FriendshipAction) -> Void
  ) -> some View {
    switch user.friendshipStatus {
    case .notRelated:
      Button("Add") { onAction(user, .sendRequest) }
        .buttonStyle(.borderedProminent)

    case .sent:
      Button("Cancel Request") { onAction(user, .deleteFriend) }
        .buttonStyle(.bordered)

    case .received:
      HStack {
        Button("Reject") {
          onAction(user, .deleteFriend)
        }
        .buttonStyle(.bordered)
        Button("Accept") {
          onAction(user, .acceptRequest)
        }
        .buttonStyle(.borderedProminent)
      }

    case .friend, nil:
      Button("Remove") {
        onAction(user, .deleteFriend)
      }
      .buttonStyle(.bordered)

    case .blocked:
      Button("Blocked") {}  // Disabled, managed via the kebab menu
        .disabled(true)
        .buttonStyle(.bordered)
    }
  }
}
