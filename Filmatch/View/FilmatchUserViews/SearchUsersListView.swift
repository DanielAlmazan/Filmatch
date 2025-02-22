//
//  SearchUsersListView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct SearchUsersListView: View {
  let users: [FilmatchUser]
  
  let onLastAppeared: () -> Void
  
  var body: some View {
    VStack {
      List {
        ForEach(users) { user in
          UserListRow(user: user, areFriends: false)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 11, leading: 0, bottom: 11, trailing: 0))
        }
        .listRowBackground(Color.clear)
      }
      .listStyle(.plain)
      .scrollContentBackground(.hidden)
      
    }
  }
}

#Preview {
  VStack {
    SearchUsersListView(
      users: [
        .default,
        .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil),
        .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil),
        .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil)
      ]
    ) { print("Last user appeared") }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
}
