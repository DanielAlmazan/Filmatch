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
//  @State private var isGridSelected: Bool = true
  
//  @State private var selectedUser: FilmatchUser?
//  @State private var showActionSheet: Bool = false

  init(searchUserVm: SearchUserViewModel) {
    self.searchUserVm = searchUserVm
  }

  var body: some View {
    VStack {
      SearchField(query: self.$searchUserVm.query, onSubmit: searchUsers)
//      HStack {
//        GridSelectorButton(isGridSelected: $isGridSelected)
//      }
      
      if let users = self.searchUserVm.users, !users.isEmpty {
//        if isGridSelected {
//          SearchUsersGridView(columns: columns, users: users) { user in
//            self.selectedUser = user
//            self.showActionSheet = true
//          } onLastAppeared: {
//            self.searchUsers()
//          }
//        } else {
          SearchUsersListView(
            users: users,
            onAction: { user, action in Task { await searchUserVm.handleFriendshipAction(for: user, action: action) } },
            onLastAppeared: { self.searchUsers() }
          )
//        }
      }
      
      if self.searchUserVm.isLoading {
        ProgressView()
      }
    }
    .padding()
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle("Friends")
//    .actionSheet(isPresented: $showActionSheet) {
//      guard let user = selectedUser else {
//        return ActionSheet(title: Text("Error"), message: Text("No user selected"), buttons: [.cancel()])
//      }
//      return FriendshipActionSheetProvider.getActionSheet(
//        for: user,
//        onAction: {user, action in Task { await searchUserVm.handleFriendshipAction(for: user, action: action) } }
//      )
//    }
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
