//
//  MatchesWithFriendContainerView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 15/3/25.
//

import SwiftUI

struct MatchesWithFriendContainerView: View {
  @Environment(OtterMatchGoRepositoryImpl.self) var repository

  let friendMatch: SimpleFriendMatch
  let mediaType: MediaType
  let onLastFriendAppeared: () -> Void
  let onLastItemAppeared: () -> Void

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        FriendHeaderView(user: friendMatch.user)

        Spacer()

        NavigationLink {
          AllMatchesWithFriendView(
            repository: repository,
            matches: friendMatch.matches,
            mediaType: mediaType,
            simpleFriendMatch: friendMatch,
            onLastAppeared: onLastItemAppeared
          )
          .navigationTitle(friendMatch.user.username ?? "Unknown")
          .background(.bgBase)
        } label: {
          Text("See all")
        }
      }

      MatchesRowView(matches: friendMatch.matches, cornerRadius: 4)
    }
    .onAppear {
      onLastFriendAppeared()
    }
  }
}

#Preview {
  let movieRepository = MoviesRepositoryImpl(
    datasource: JsonMoviesRemoteDatasource()
  )
  let tvRepository = TvSeriesRepositoryImpl(
    datasource: JsonTvSeriesDatasource()
  )
  let otterMatchRepository = OtterMatchGoRepositoryImpl(datasource: JsonOtterMatchDatasource(client: TMDBJsonClient()))
  
  NavigationStack {
    VStack {
      MatchesWithFriendContainerView(
        friendMatch: .`default`,
        mediaType: .movie
      ) {
        print("Last friend appeared")
      } onLastItemAppeared: {
        print("Last appeared")
      }
      .frame(maxHeight: 200)
      .padding()
      .background(.bgContainer)
      .clipShape(.rect(cornerRadius: 20))
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .background(.bgBase)
  }
  .environment(movieRepository)
  .environment(tvRepository)
  .environment(otterMatchRepository)
}
