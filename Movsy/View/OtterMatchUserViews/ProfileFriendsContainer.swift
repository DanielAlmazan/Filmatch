//
//  ProfileFriendsContainer.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct ProfileFriendsContainer: View {
  let title: LocalizedStringKey
  let height: CGFloat
  
  @Binding var isLoading: Bool
  @Binding var friends: [MovsyUser]?
  
  @Environment(MovsyGoRepositoryImpl.self) private var movsyGoRepository
  @Environment(FriendsViewModel.self) private var friendsVm

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(title)
          .font(.headline)
        
        Spacer()
        
        NavigationLink {
          MyFriendsView(friendsVm: friendsVm)
            .background(.bgBase)
        } label: {
          Text("See all")
        }
        .disabled(friends?.isEmpty ?? true)
      }
      Group {
        MyFriendsRow(
          friends: friends,
          height: height,
          movsyRepository: movsyGoRepository
        )
      }
      .frame(height: height * 1.5)
      .frame(maxWidth: .infinity)
      .scrollClipDisabled()
    }
    .padding()
    .background(.bgContainer)
    .clipShape(.rect(cornerRadius: 10))
  }
}

// MARK: - Preview Not Simulating loading
#Preview {
  @Previewable @State var isLoading: Bool = true
  @Previewable @State var friends: [MovsyUser]? = [
    .default,
    .init(
      email: nil,
      username: "miirii",
      uid: "FirebaseUID1",
      photoUrl: nil,
      friendshipStatus: .notRelated,
      isEmailVerified: nil
    ),
    .init(
      email: nil,
      username: "fake_miirii",
      uid: "FirebaseUID2",
      photoUrl: nil,
      friendshipStatus: .friend,
      isEmailVerified: nil
    ),
    .init(
      email: nil,
      username: "miiraculous_one",
      uid: "FirebaseUID",
      photoUrl: nil,
      friendshipStatus: .received,
      isEmailVerified: nil
    )
  ]
  @Previewable @State var friendsVm: FriendsViewModel = .init(
    movsyRepository: MovsyGoRepositoryImpl(
      datasource: MovsyGoDatasourceImpl(
        client: MovsyHttpClient()
      )
    )
  )

  VStack {
    NavigationStack {
      ProfileFriendsContainer(
        title: "My Friends",
        height: 90,
        isLoading: .constant(false),
        friends: $friends)
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
  .environment(friendsVm)
  .environment(
    MovsyGoRepositoryImpl(
      datasource: MovsyGoDatasourceImpl(
        client: MovsyHttpClient()
      )
    )
  )
}

// MARK: - Preview Simulating loading
#Preview("Simulating loading") {
  @Previewable @State var isLoading: Bool = true
  @Previewable @State var friends: [MovsyUser]?
  @Previewable @State var friendsVm: FriendsViewModel = .init(
    movsyRepository: MovsyGoRepositoryImpl(
      datasource: MovsyGoDatasourceImpl(
        client: MovsyHttpClient()
      )
    )
  )

  VStack {
    ProfileFriendsContainer(
      title: "My Friends",
      height: 90,
      isLoading: $isLoading,
      friends: $friends)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        isLoading = false
        friends = [
          .default,
          .init(
            email: nil,
            username: "miirii",
            uid: "FirebaseUID1",
            photoUrl: nil,
            friendshipStatus: .notRelated,
            isEmailVerified: nil
          ),
          .init(
            email: nil,
            username: "fake_miirii",
            uid: "FirebaseUID2",
            photoUrl: nil,
            friendshipStatus: .friend,
            isEmailVerified: nil
          ),
          .init(
            email: nil,
            username: "miiraculous_one",
            uid: "FirebaseUID",
            photoUrl: nil,
            friendshipStatus: .received,
            isEmailVerified: nil
          )
        ]
      }
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
  .environment(friendsVm)
  .environment(
    MovsyGoRepositoryImpl(
      datasource: MovsyGoDatasourceImpl(
        client: MovsyHttpClient()
      )
    )
  )
}
