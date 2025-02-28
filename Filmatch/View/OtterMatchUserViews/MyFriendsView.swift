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
      if let users = self.friendsVm.friendRequests, !users.isEmpty {
        FriendRequestsView(
          users: users,
          onAction: handleFriendshipAction,
          onDelete: onRequestProcessed,
          onLastAppeared: onLastRequestAppeared
        )
      }

      if friendsVm.isLoadingFriends {
        ProgressView("Loading friends...")
      } else if !friendsVm.filteredFriends.isEmpty {
        UsersListView(
          users: friendsVm.filteredFriends,
          onAction: handleFriendshipAction,
          onDelete: onFriendRemoval,
          onLastAppeared: onLastFriendAppeared
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
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
  
  private func onLastRequestAppeared() {
    if self.friendsVm.isLoadingRequests {
      Task { await friendsVm.loadFriendRequests() }
    }
  }
  
  private func onLastFriendAppeared() {
    if self.friendsVm.isLoadingFriends {
      Task { await friendsVm.loadFriends() }
    }
  }
  
  private func onRequestProcessed(user: OtterMatchUser) {
    self.friendsVm.onRequestRemoval(user: user)
  }
  
  private func onFriendRemoval(user: OtterMatchUser) {
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
