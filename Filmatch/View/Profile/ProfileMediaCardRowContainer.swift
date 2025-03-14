//
//  ProfileMediaCardRowContainer.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/2/25.
//

import SwiftUI

struct ProfileMediaCardRowContainer: View {
  let title: String
  let height: CGFloat
  
  @Binding var isLoading: Bool
  var items: [any DiscoverItem]?
  
  let onLastAppeared: () -> Void
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Text(title)
          .font(.headline)
        
        Spacer()
        
        if let items {
          NavigationLink {
            UserMediaView(title: title, items: items, onLastAppeared: onLastAppeared)
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
      title: "Liked",
      height: 100,
      isLoading: .constant(false),
      items: [DiscoverMovieItem.default],
      onLastAppeared: { print("Last appeared") }
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
