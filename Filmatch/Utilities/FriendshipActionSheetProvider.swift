//
//  FriendshipActionSheetProvider.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/2/25.
//

enum FriendshipAction {
  case sendRequest
  case cancelRequest
  case acceptRequest
  case rejectRequest
  case deleteFriend
  case block
  case unblock
}

import SwiftUI

struct FriendshipActionSheetProvider {
  static func getActionSheet(
    for user: FilmatchUser,
    onSendRequest: @escaping () -> Void,
    onCancelRequest: @escaping () -> Void,
    onAcceptRequest: @escaping () -> Void,
    onRejectRequest: @escaping () -> Void,
    onDeleteFriend: @escaping () -> Void,
    onBlock: @escaping () -> Void,
    onUnblock: @escaping () -> Void
  ) -> ActionSheet {
    
    let actions: [ActionSheet.Button] = {
      switch user.friendshipStatus {
      case .notRelated:
        return [
          .default(Text("Send friend request"), action: onSendRequest),
          .destructive(Text("Block"), action: onBlock),
          .cancel()
        ]
      case .sent:
        return [
          .default(Text("Cancel friend request"), action: onCancelRequest),
          .destructive(Text("Block"), action: onBlock),
          .cancel()
        ]
      case .received:
        return [
          .default(Text("Accept"), action: onAcceptRequest),
          .default(Text("Reject"), action: onRejectRequest),
          .destructive(Text("Block"), action: onBlock),
          .cancel()
        ]
      case .friend:
        return [
          .default(Text("Delete friend"), action: onDeleteFriend),
          .destructive(Text("Block"), action: onBlock),
          .cancel()
        ]
      case .blocked:
        return [
          .default(Text("Unblock"), action: onUnblock),
          .cancel()
        ]
      case nil:
        return [.cancel()]
      }
    }()
    
    return ActionSheet(title: Text(user.username ?? "User"), buttons: actions)
  }
}
