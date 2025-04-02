//
//  ProfileMediaCardRowContainer.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/2/25.
//

import SwiftUI

struct ProfileMediaCardRowContainer: View {
  let user: OtterMatchUser
  let status: InterestStatus
  let media: MediaType
  let height: CGFloat
  
  @Binding var isLoading: Bool
  var items: [any DiscoverItem]?
  
  @Environment(OtterMatchGoRepositoryImpl.self) var repository

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(status.listName)
          .font(.headline)
        
        Spacer()
        
        if let items {
          NavigationLink {
            ScrollView {
              UserMediaView(
                repository: repository,
                user: user,
                status: status,
                media: media,
                items: items)
            }
            .background(.bgBase)
          } label: {
            Text("See all")
              .foregroundStyle(.accent)
          }
        }
      }
      Group {
        if self.isLoading {
          ProgressView("Loading...")
        } else if let items, !items.isEmpty {
          ProfileMediaCardsRow(items: items, cornerRadius: 5)
        } else {
          Text("No results")
        }
      }
      .frame(height: height)
      .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
  NavigationStack {
    ProfileMediaCardRowContainer(
      user: .default,
      status: .interested,
      media: .movie,
      height: 100,
      isLoading: .constant(false),
      items: [DiscoverMovieItem.default]
    )
  }
  .environment(
    OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(
        client: OtterMatchHttpClient()
      )
    )
  )
}
