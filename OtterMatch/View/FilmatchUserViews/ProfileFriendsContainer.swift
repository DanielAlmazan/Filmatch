//
//  ProfileFriendsContainer.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct ProfileFriendsContainer: View {
  let title: String
  let height: CGFloat
  
  @Binding var isLoading: Bool
  @Binding var friends: [OtterMatchUser]?
  
  @Environment(OtterMatchGoRepositoryImpl.self) private var otterMatchGoRepository

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(title)
          .font(.headline)
        
        Spacer()
        
        NavigationLink {
          MyFriendsView()
        } label: {
          Text("See all")
        }
      }
      Group {
        if self.isLoading {
          ProgressView("Loading...")
        } else if let friends {
          MyFriendsRow(
            friends: friends,
            height: height,
            otterMatchRepository: otterMatchGoRepository
          )
        } else {
          Text("No results")
        }
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
  @Previewable @State var friends: [OtterMatchUser]? = [
    .default,
    .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil, friendshipStatus: .notRelated),
    .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil, friendshipStatus: .friend),
    .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil, friendshipStatus: .received)
  ]
  
  VStack {
    ProfileFriendsContainer(
      title: "My Friends",
      height: 90,
      isLoading: .constant(false),
      friends: $friends)
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
  .environment(
    OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(
        client: OtterMatchHttpClient()
      )
    )
  )
}

// MARK: - Preview Simulating loading
#Preview("Simulating loading") {
  @Previewable @State var isLoading: Bool = true
  @Previewable @State var friends: [OtterMatchUser]?

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
          .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil, friendshipStatus: .notRelated),
          .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil, friendshipStatus: .friend),
          .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil, friendshipStatus: .received)
        ]
      }
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
  .environment(
    OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(
        client: OtterMatchHttpClient()
      )
    )
  )
}
