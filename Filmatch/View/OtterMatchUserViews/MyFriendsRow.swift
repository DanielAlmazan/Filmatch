//
//  MyFriendsRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct MyFriendsRow: View {
  let friends: [OtterMatchUser]
  let height: CGFloat

  @State private var isShowingSearchUsersView: Bool = false
  @State private var searchUsersVm: SearchUserViewModel

  init(friends: [OtterMatchUser], height: CGFloat, otterMatchRepository: OtterMatchGoRepository) {
    self.friends = friends
    self.height = height
    self.searchUsersVm = .init(repository: otterMatchRepository)
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
        .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil, friendshipStatus: .notRelated),
        .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil, friendshipStatus: .friend),
        .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil, friendshipStatus: .received)
      ],
      height: 100,
      otterMatchRepository: OtterMatchGoRepositoryImpl(
        datasource: OtterMatchGoDatasourceImpl(
          client: OtterMatchHttpClient()
        )
      )
    )
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
  .environment(
    OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(
        client: OtterMatchHttpClient()
      )
    )
  )
}
