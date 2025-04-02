//
//  PersonTvSeriesCreditsAsCastRow.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 14/1/25.
//

import SwiftUI

struct PersonTvSeriesCreditsAsCastRow: View {
  let tvSeries: [PersonTvSeriesCreditsAsCastMember]

  @Environment(TvSeriesRepositoryImpl.self) var tvSeriesRepository

  var body: some View {
    if tvSeries.isEmpty {
      Text("No tv series found")
        .frame(maxWidth: .infinity, alignment: .center)
    } else {
      VStack(alignment: .leading, spacing: 8) {
        Text("As cast member...")
          .font(.headline)
          .padding(.horizontal)

        ScrollView(.horizontal, showsIndicators: true) {
          LazyHGrid(rows: [GridItem()]) {
            ForEach(tvSeries) { show in
              NavigationLink(
                destination: TvSeriesDetailView(
                  repository: tvSeriesRepository, seriesId: show.id)
              ) {
                VStack(alignment: .leading) {
                  PosterView(
                    imageUrl: show.posterPath, size: .w500, posterType: .movie
                  )
                  .clipShape(.rect(cornerRadius: 10))
                  if let title = show.name {
                    Text("In \"\(title)\"")
                      .font(.headline)
                  }
                  if let character = show.character {
                    Text("As \(character)")
                      .font(.caption)
                  }
                }
                .lineLimit(1)
                .frame(width: 200)
              }
            }
          }
        }
        .scrollClipDisabled()
      }
    }
  }
}

#Preview {
  PersonTvSeriesCreditsAsCastRow(tvSeries: [.default])
    .environment(TvSeriesRepositoryImpl(datasource: JsonTvSeriesDatasource()))
}
