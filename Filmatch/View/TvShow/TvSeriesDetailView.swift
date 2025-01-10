//
//  TvSeriesDetailView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/1/25.
//

import SwiftUI

struct TvSeriesDetailView: View {
  @State private var vm: TvSeriesDetailViewModel

  let seriesId: Int
  
  init(repository: TvSeriesRepository, seriesId: Int) {
    self.vm = .init(repository: repository)
    self.seriesId = seriesId
  }

  var body: some View {
    NavigationStack {
      VStack {
        if vm.isTvSeriesLoading {
          ProgressView("Loading...")
        } else if let tvSeries = vm.tvSeries {
          PosterView(imageUrl: tvSeries.posterPath, size: "w500")
          
          VStack(alignment: .leading, spacing: 16) {
            HStack {
              VotesAverageCircleView(averageVotes: tvSeries.voteAverage)
              
              if !tvSeries.genres.isEmpty {
                Text(Utilities.parseNamesList(tvSeries.genres.map { $0.name ?? "nil" }))
                  .font(.subheadline)
              }
              
              Spacer()
              
              Text("\(tvSeries.numberOfSeasons) seasons")
            }
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .background(.bgBase)
      .ignoresSafeArea(edges: .top)
      .task {
        vm.loadTvSeries(byId: seriesId)
      }
    }
  }
}

#Preview {
  TvSeriesDetailView(
    repository: TvSeriesRepositoryImpl(
      remoteDatasource: JsonTvSeriesDatasource()
    ),
    seriesId: 93405
  )
}
