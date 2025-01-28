//
//  TvSeriesFirstDetailsRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/1/25.
//

import SwiftUI

struct TvSeriesFirstDetailsRow: View {
  let voteAverage: Double
  let genres: [Genre]
  let numberOfSeasons: Int?
  let providers: WatchProvidersResponse?

  @State private var showProviders = false

  var body: some View {
    HStack {
      VotesAverageCircleView(averageVotes: voteAverage)

      if !genres.isEmpty {
        Text(Utilities.parseNamesList(genres.map { $0.name ?? "unknown" }))
          .font(.subheadline)
      }

      Spacer()

      Button {
        showProviders = true
      } label: {
        Text("Watch on...")
          .font(.caption)
      }
      .disabled(providers?.isEmpty ?? true)
      .buttonStyle(.bordered)
      .sheet(isPresented: $showProviders) {
        if let providers {
          ProvidersView(providers: providers)
        }
      }

      if let numberOfSeasons {
        Text("\(numberOfSeasons) seasons")
      }
    }
  }
}

#Preview {
  TvSeriesFirstDetailsRow(
    voteAverage: 4,
    genres: [
      .init(id: 1, name: "Action"),
      .init(id: 2, name: "Comedy"),
    ],
    numberOfSeasons: 1,
    providers: .default)
//    providers: nil)
}
