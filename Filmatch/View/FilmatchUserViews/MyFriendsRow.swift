//
//  MyFriendsRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct MyFriendsRow: View {
  let friends: [FilmatchUser]
  let height: CGFloat

  @State private var isShowingSearchUsersView: Bool = false
  @State private var searchUsersVm: SearchUserViewModel

  init(friends: [FilmatchUser], height: CGFloat, filmatchRepository: FilmatchGoRepository) {
    self.friends = friends
    self.height = height
    self.searchUsersVm = .init(repository: filmatchRepository)
  }

  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 10) {
        AddFriendsButton(size: height) {
          isShowingSearchUsersView = true
        }.sheet(isPresented: $isShowingSearchUsersView) {
          NavigationStack {
            SearchUsersView(searchUserVm: self.searchUsersVm)
          }
        }
        
        if !friends.isEmpty {
          ForEach(friends) { friend in
            SimpleUserInfoView(user: friend, size: height)
          }
        }
      }
    }
  }
}

#Preview {
  VStack {
    MyFriendsRow(
      friends: [
        .default,
        .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil),
        .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil),
        .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil)
      ],
      height: 100,
      filmatchRepository: FilmatchGoRepositoryImpl(
        datasource: FilmatchGoDatasourceImpl(
          client: FilmatchHttpClient()
        )
      )
    )
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
  .environment(
    FilmatchGoRepositoryImpl(
      datasource: FilmatchGoDatasourceImpl(
        client: FilmatchHttpClient()
      )
    )
  )
}
