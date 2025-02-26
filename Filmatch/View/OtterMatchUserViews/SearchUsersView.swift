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

  init(searchUserVm: SearchUserViewModel) {
    self.searchUserVm = searchUserVm
  }

  var body: some View {
    VStack {
      SearchField(query: self.$searchUserVm.query, onSubmit: searchUsers)
      if let users = self.searchUserVm.users, !users.isEmpty {
        UsersListView(
          users: users,
          onAction: { user, action in Task { await searchUserVm.handleFriendshipAction(for: user, action: action) } },
          onLastAppeared: { self.searchUsers() }
        )
      }
      
      if self.searchUserVm.isLoading {
        ProgressView()
      }
    }
    .padding()
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle("Add Friends")
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
          repository: OtterMatchGoRepositoryImpl(
            datasource: OtterMatchGoDatasourceImpl(
              client: OtterMatchHttpClient()
            )
          )
        )
      )
    }
  }

}
