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
          PosterView(imageUrl: tvSeries.posterPath, size: "w500", posterType: .movie)
          
          VStack(alignment: .leading, spacing: 16) {
            TvSeriesFirstDetailsRow(
              voteAverage: tvSeries.voteAverage,
              genres: tvSeries.genres,
              numberOfSeasons: tvSeries.numberOfSeasons,
              providers: vm.providers)
            .padding()
            .lineLimit(1)
          }
        } else if let error = vm.errorMessage {
          Text(error)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
      .background(.bgBase)
      .ignoresSafeArea(edges: .top)
      .task {
        vm.loadTvSeries(byId: seriesId)
        vm.loadProviders(forTvSeriesId: seriesId)
      }
    }
  }
}

#Preview {
  TvSeriesDetailView(
    repository: TvSeriesRepositoryImpl(
      datasource: JsonTvSeriesDatasource()
    ),
    seriesId: 93405
  )
}
