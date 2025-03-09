//
//  MyFriendsView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 25/2/25.
//

import SwiftUI

struct MyFriendsView: View {
  @State private var friendsVm: FriendsViewModel
  @State private var isFriendshipRequestsExpanded: Bool = true
  
  init(friendsVm: FriendsViewModel) {
    self.friendsVm = friendsVm
  }
  
  var body: some View {
    VStack {
      SearchField(query: self.$friendsVm.searchText) {
        searchUsers()
      }
      .padding()
      
      List {
        if let requests = self.friendsVm.friendRequests {
          Section(isExpanded: $isFriendshipRequestsExpanded, content: {
            ForEach(requests) { user in
              UserListRow(
                user: user,
                onAction: onRequestTapped
              )
              .onAppear {
                if requests.last == user {
                  onLastRequestAppeared()
                }
              }
              .listRowSeparator(.hidden)
            }
            .listRowBackground(Color.clear)
          }, header: {
            Text("Friendship Requests")
              .font(.title2)
              .fontWeight(.semibold)
          })
        }

        if let friends = self.friendsVm.friends {
          Section(content: {
            ForEach(friends) { friend in
              UserListRow(
                user: friend,
                onAction: onFriendTapped
              )
              .onAppear {
                if friends.last == friend {
                  onLastFriendAppeared()
                }
              }
              .listRowSeparator(.hidden)
            }
            .listRowBackground(Color.clear)
          }, header: {
            Text("Friends")
              .font(.title2)
              .fontWeight(.semibold)
          })
        }
      }
      .listStyle(.sidebar)
      .scrollContentBackground(.hidden)
    }
    .navigationTitle("My Friends")
    .task { initLists() }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
  
  private func searchUsers() {
    Task {
      await friendsVm.searchUsers()
    }
  }
  
  private func onFriendTapped(for user: Binding<OtterMatchUser>, do action: FriendshipAction) {
    self.friendsVm.handleFriendshipAction(for: user, do: action)
  }

  private func onRequestTapped(for user: Binding<OtterMatchUser>, do action: FriendshipAction) {
    self.friendsVm.handleFriendshipAction(for: user, do: action)
  }
  
  private func onLastRequestAppeared() {
    if self.friendsVm.isLoadingRequests {
      Task { await friendsVm.loadMoreFriendRequests() }
    }
  }
  
  private func onLastFriendAppeared() {
    if self.friendsVm.isLoadingFriends {
      Task { await friendsVm.loadMoreFriends() }
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
