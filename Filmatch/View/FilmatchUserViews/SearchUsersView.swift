//
//  SearchUsersView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct SearchUsersView: View {
  private let columns = [
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16),
    GridItem(.flexible(), spacing: 16),
  ]
  
  @State private var searchUserVm: SearchUserViewModel
  @State private var isGridSelected: Bool = true
  
  @State private var selectedUser: FilmatchUser?
  @State private var showActionSheet: Bool = false

  init(searchUserVm: SearchUserViewModel) {
    self.searchUserVm = searchUserVm
  }

  var body: some View {
    VStack {
      HStack {
        SearchField(query: self.$searchUserVm.query, onSubmit: searchUsers)
        GridSelectorButton(isGridSelected: $isGridSelected)
      }
      
      if let users = self.searchUserVm.users, !users.isEmpty {
        if isGridSelected {
          SearchUsersGridView(columns: columns, users: users) { user in
            self.selectedUser = user
            self.showActionSheet = true
          } onLastAppeared: {
            self.searchUsers()
          }
        } else {
          SearchUsersListView(
            users: users,
            onSendRequest: { user in Task { await searchUserVm.handleFriendshipAction(for: user, action: .sendRequest) } },
            onAcceptRequest: { user in Task { await searchUserVm.handleFriendshipAction(for: user, action: .acceptRequest) } },
            onDeleteFriendship: { user in Task { await searchUserVm.handleFriendshipAction(for: user, action: .deleteFriend) } },
            onBlock: { user in Task { await searchUserVm.handleFriendshipAction(for: user, action: .block) } },
            onUnblock: { user in Task { await searchUserVm.handleFriendshipAction(for: user, action: .unblock) } },
            onLastAppeared: { self.searchUsers() }
          )
        }
      }
      
      if self.searchUserVm.isLoading {
        ProgressView()
      }
    }
    .padding()
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle("Friends")
    .actionSheet(isPresented: $showActionSheet) {
      guard let user = selectedUser else {
        return ActionSheet(title: Text("Error"), message: Text("No user selected"), buttons: [.cancel()])
      }
      return FriendshipActionSheetProvider.getActionSheet(
        for: user,
        onSendRequest: { Task { await searchUserVm.handleFriendshipAction(for: user, action: .sendRequest) } },
        onCancelRequest: { Task { await searchUserVm.handleFriendshipAction(for: user, action: .cancelRequest) } },
        onAcceptRequest: { Task { await searchUserVm.handleFriendshipAction(for: user, action: .acceptRequest) } },
        onRejectRequest: { Task { await searchUserVm.handleFriendshipAction(for: user, action: .rejectRequest) } },
        onDeleteFriend: { Task { await searchUserVm.handleFriendshipAction(for: user, action: .deleteFriend) } },
        onBlock: { Task { await searchUserVm.handleFriendshipAction(for: user, action: .block) } },
        onUnblock: { Task { await searchUserVm.handleFriendshipAction(for: user, action: .unblock) } }
      )
    }
  }
  
  private func searchUsers() {
    Task {
      await self.searchUserVm.searchUsers()
    }
  }
}

#Preview {
  @Previewable @State var isActive = true
  
  VStack {
    Button("Open search friends view") {
      isActive = true
    }
  }
  .background(.bgBase)
  .sheet(isPresented: $isActive) {
    NavigationStack {
      SearchUsersView(
        searchUserVm: SearchUserViewModel(
          repository: FilmatchGoRepositoryImpl(
            datasource: FilmatchGoDatasourceImpl(
              client: FilmatchHttpClient()
            )
          )
        )
      )
    }
  }

}
