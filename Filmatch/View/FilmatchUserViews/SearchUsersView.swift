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
          SearchUsersGridView(columns: columns, users: users) {
            self.searchUsers()
          }
        } else {
          SearchUsersListView(users: users) {
            self.searchUsers()
          }
        }
      }
      
      if self.searchUserVm.isLoading {
        ProgressView()
      }
    }
    .padding()
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle("Friends")
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
