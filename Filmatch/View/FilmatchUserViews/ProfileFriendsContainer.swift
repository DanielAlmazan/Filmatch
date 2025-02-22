//
//  ProfileFriendsContainer.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/2/25.
//

import SwiftUI

struct ProfileFriendsContainer: View {
  let title: String
  let height: CGFloat

  @Binding var isLoading: Bool
  @Binding var friends: [FilmatchUser]?

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.headline)
      Group {
        if self.isLoading {
          ProgressView("Loading...")
        } else if let friends, !friends.isEmpty {
          MyFriendsRow(friends: friends) { friend in
            SimpleUserInfoView(user: friend, size: height)
          }
        } else {
          Text("No results")
        }
      }
      .frame(height: height * 1.5)
      .frame(maxWidth: .infinity)
      .scrollClipDisabled()
      .padding()
      .background(.bgContainer)
      .clipShape(.rect(cornerRadius: 10))
    }
  }
}

#Preview {
  @Previewable @State var isLoading: Bool = true
  @Previewable @State var friends: [FilmatchUser]?

  VStack {
    ProfileFriendsContainer(
      title: "My Friends",
      height: 90,
      isLoading: $isLoading,
      friends: $friends)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        isLoading = false
        friends = [
          .default,
          .init(email: nil, username: "miirii", uid: "FirebaseUID1"),
          .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2"),
          .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID")
        ]
      }
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
}
