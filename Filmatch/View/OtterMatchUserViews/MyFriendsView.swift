//
//  MyFriendsView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 25/2/25.
//

import SwiftUI

struct MyFriendsView: View {
  @State private var friendsVm: FriendsViewModel
  
  init(friendsVm: FriendsViewModel) {
    self.friendsVm = friendsVm
  }
  
  var body: some View {
    VStack {
      if friendsVm.isLoadingFriends {
        ProgressView("Loading friends...")
      } else if !friendsVm.filteredFriends.isEmpty {
        UsersListView(
          users: friendsVm.filteredFriends,
          onAction: handleFriendshipAction,
          onDelete: onDelete,
          onLastAppeared: { Task { await friendsVm.loadFriends() } }
        )
      } else {
        Text("No friends found")
          .foregroundColor(.gray)
      }
    }
    .searchable(text: self.$friendsVm.searchText)
    .navigationTitle("My Friends")
    .padding()
    .task { initLists() }
  }
  
  private func onDelete(user: OtterMatchUser) {
    self.friendsVm.onFriendRemoval(user: user)
  }
  
  private func handleFriendshipAction(user: Binding<OtterMatchUser>, do action: FriendshipAction) {
    Task {
      await friendsVm.handleFriendshipAction(for: user, do: action)
    }
  }
  
  private func initLists() {
    Task {
      if self.friendsVm.friends == nil && !self.friendsVm.isLoadingFriends {
        await self.friendsVm.loadFriends()
      }
      
      if self.friendsVm.friendRequests == nil && !self.friendsVm.isLoadingRequests {
        await self.friendsVm.loadFriendRequests()
      }
    }
  }
}

#Preview {
  @Previewable var friendsVm = FriendsViewModel(
    otterMatchRepository: OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(
        client: OtterMatchHttpClient()
      )
    )
  )
  
  NavigationStack {
    MyFriendsView(friendsVm: friendsVm)
  }
}
