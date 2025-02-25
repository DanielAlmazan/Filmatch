//
//  ProfileMediaCardRowContainer.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/2/25.
//

import SwiftUI

struct ProfileMediaCardRowContainer: View {
  let title: String
  let height: CGFloat
  
  @Binding var isLoading: Bool
  @Binding var items: [any DiscoverItem]?
  
  var body: some View {
    VStack(alignment: .leading) {
      Text(title)
        .font(.headline)
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
  ProfileMediaCardRowContainer(title: "Liked", height: 100, isLoading: .constant(false), items: .constant([DiscoverMovieItem.default]))
    .environment(
      OtterMatchGoRepositoryImpl(
        datasource: OtterMatchGoDatasourceImpl(
          client: OtterMatchHttpClient()
        )
      )
    )
}
