//
//  PersonTvSeriesCreditsAsCrewRow.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 16/1/25.
//

import SwiftUI

struct PersonTvSeriesCreditsAsCrewRow: View {
  let tvSeries: [PersonTvSeriesCreditsAsCrewMember]
  let width: CGFloat

  @Environment(TvSeriesRepositoryImpl.self) var tvSeriesRepository

  var body: some View {
    if tvSeries.isEmpty {
      Text("No tv series found")
        .frame(maxWidth: .infinity, alignment: .center)
    } else {
      VStack(alignment: .leading, spacing: 8) {
        Text("As crew member...")
          .font(.headline)

        ScrollView(.horizontal) {
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
                  if let character = show.job {
                    Text("As \(character)")
                      .font(.caption)
                  }
                }
                .lineLimit(1)
                .frame(width: width)
              }
            }
          }
        }
//        .scrollClipDisabled()
      }
    }
  }
}

#Preview {
  PersonTvSeriesCreditsAsCrewRow(tvSeries: [], width: 100)
    .environment(TvSeriesRepositoryImpl(datasource: JsonTvSeriesDatasource()))
}
