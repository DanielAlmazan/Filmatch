//
//  ProfileMediaCardRowContainer.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/2/25.
//

import SwiftUI

struct ProfileMediaCardRowContainer: View {
  let status: InterestStatus
  let media: MediaType
  let height: CGFloat

  @Binding var isLoading: Bool
  @Binding var items: [any DiscoverItem]?

  let updateItem: (any DiscoverItem, InterestStatus?) -> Void

  @Environment(OtterMatchGoRepositoryImpl.self) var repository
  @Environment(AuthenticationViewModel.self) var authVm

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
                user: authVm.currentUser,
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
        } else if !(items?.isEmpty ?? true) {
          ProfileMediaCardsRow(items: self.$items, cornerRadius: 5, updateItem: updateItem)
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
  @Previewable @State var movies: [any DiscoverItem]? = [DiscoverMovieItem.default]

  NavigationStack {
    ProfileMediaCardRowContainer(
      status: .interested,
      media: .movie,
      height: 100,
      isLoading: .constant(false),
      items: $movies
    ) { item, newStatus in
      print("Update item \(item) from status \(item.status ?? .pending) to status \(newStatus ?? .pending)")
    }
  }
  .environment(
    OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(
        client: OtterMatchHttpClient()
      )
    )
  )
  .environment(
    AuthenticationViewModel(
      authenticationRepository: AuthenticationFirebaseRepository(
        dataSource: AuthenticationFirebaseDataSource()
      ),
      otterMatchRepository: OtterMatchGoRepositoryImpl(
        datasource: OtterMatchGoDatasourceImpl(
          client: OtterMatchHttpClient(
            urlBase: API.otterMatchBaseURL)
        )
      )
    )
  )
}
