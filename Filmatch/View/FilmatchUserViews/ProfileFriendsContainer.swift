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
  
  @Environment(FilmatchGoRepositoryImpl.self) private var filmatchGoRepository

  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.headline)
      Group {
        if self.isLoading {
          ProgressView("Loading...")
        } else if let friends {
          MyFriendsRow(
            friends: friends,
            height: height,
            filmatchRepository: filmatchGoRepository
          )
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

// MARK: - Preview Not Simulating loading
#Preview {
  @Previewable @State var isLoading: Bool = true
  @Previewable @State var friends: [FilmatchUser]? = [
    .default,
    .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil),
    .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil),
    .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil)
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
    FilmatchGoRepositoryImpl(
      datasource: FilmatchGoDatasourceImpl(
        client: FilmatchHttpClient()
      )
    )
  )
}

// MARK: - Preview Simulating loading
#Preview("Simulating loading") {
  @Previewable @State var isLoading: Bool = true
  @Previewable @State var friends: [FilmatchUser]?

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
          .init(email: nil, username: "miirii", uid: "FirebaseUID1", photoUrl: nil),
          .init(email: nil, username: "fake_miirii", uid: "FirebaseUID2", photoUrl: nil),
          .init(email: nil, username: "miiraculous_one", uid: "FirebaseUID", photoUrl: nil)
        ]
      }
    }
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(.bgBase)
  .environment(
    FilmatchGoRepositoryImpl(
      datasource: FilmatchGoDatasourceImpl(
        client: FilmatchHttpClient()
      )
    )
  )
}
