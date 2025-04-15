//
//  MyFriendsRow.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct MyFriendsRow: View {
  let friends: [MovsyUser]?
  let height: CGFloat

  @Environment(MovsyGoRepositoryImpl.self) var movsyRepository
  @Environment(FriendsViewModel.self) var friendsVm

  @State private var isShowingSearchUsersView: Bool = false
  @State private var searchUsersVm: SearchUserViewModel

  init(friends: [MovsyUser]?, height: CGFloat, movsyRepository: MovsyGoRepository) {
    self.friends = friends
    self.height = height
    self.searchUsersVm = .init(repository: movsyRepository)
  }

  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 10) {
        AddFriendsButton(size: height) {
          isShowingSearchUsersView = true
        }.sheet(isPresented: $isShowingSearchUsersView) {
          NavigationStack {
            SearchUsersView(searchUserVm: self.searchUsersVm, friendsVm: friendsVm)
          }
        }

        if let friends, !friends.isEmpty {
          ForEach(friends) { friend in
            SimpleUserInfoView(user: friend, size: height)
          }
        }
      }
    }
  }
}

#Preview {
  let movsyRepository = MovsyGoRepositoryImpl(
    datasource: MovsyGoDatasourceImpl(
      client: MovsyHttpClient()
    )
  )
  let friendsVm = FriendsViewModel(
    movsyRepository: MovsyGoRepositoryImpl(
      datasource: JsonMovsyDatasource(
        client: TMDBJsonClient()
      )
    )
  )
  VStack {
    MyFriendsRow(
      friends: [
        .default,
        .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil, friendshipStatus: .notRelated),
        .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil, friendshipStatus: .friend),
        .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil, friendshipStatus: .received),
      ],
      height: 100,
      movsyRepository: MovsyGoRepositoryImpl(
        datasource: MovsyGoDatasourceImpl(
          client: MovsyHttpClient()
        )
      )
    )
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .padding()
  .background(.bgBase)
  .environment(movsyRepository)
  .environment(friendsVm)
}
