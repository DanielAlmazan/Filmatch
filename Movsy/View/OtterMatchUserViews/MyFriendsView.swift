//
//  MyFriendsView.swift
//  Movsy
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
      .padding(.horizontal)

      ScrollView {
        LazyVStack(alignment: .leading, spacing: 12) {
          if let requests = self.friendsVm.friendRequests {
            VStack(alignment: .leading) {
              HStack {
                Text("Friendship Requests")
                  .font(.title2)
                  .fontWeight(.semibold)
                Spacer()
                Button {
                  withAnimation(.bouncy(duration: 0.3)) {
                    isFriendshipRequestsExpanded.toggle()
                  }
                } label: {
                  Image(systemName: isFriendshipRequestsExpanded ? "chevron.down" : "chevron.right")
                    .symbolEffect(.bounce, value: isFriendshipRequestsExpanded)
                }
              }
              if isFriendshipRequestsExpanded {
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
                }
              }
            }
          }

          if let friends = self.friendsVm.friends {
            VStack(alignment: .leading) {
              Text("Friends")
                .font(.title2)
                .fontWeight(.semibold)
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
              }
            }
          }
        }
        .padding(.horizontal)
      }
      .refreshable {
        Task { await friendsVm.onRefresh() }
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .navigationTitle("My Friends")
    .task { initLists() }
  }

  private func searchUsers() {
    Task {
      await friendsVm.searchUsers()
    }
  }

  private func onFriendTapped(for user: Binding<MovsyUser>, do action: FriendshipAction) {
    self.friendsVm.handleFriendshipAction(for: user, do: action)
  }

  private func onRequestTapped(for user: Binding<MovsyUser>, do action: FriendshipAction) {
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
    movsyRepository: MovsyGoRepositoryImpl(
      datasource: JsonMovsyDatasource(
        client: TMDBJsonClient()
      )
    )
  )

  NavigationStack {
    MyFriendsView(friendsVm: friendsVm)
      .background(.bgBase)
  }
}
