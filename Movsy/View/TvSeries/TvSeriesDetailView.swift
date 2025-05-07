//
//  TvSeriesDetailView.swift
//  Movsy
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
          ScrollView {
            // MARK: - Poster Image
            PosterView(imageUrl: tvSeries.posterPath, size: .w500, posterType: .movie)

            VStack(alignment: .leading, spacing: 16) {
              TvSeriesFirstDetailsRow(
                voteAverage: tvSeries.voteAverage,
                genres: tvSeries.genres,
                numberOfSeasons: tvSeries.numberOfSeasons,
                providers: vm.providers)
              .padding()
              .lineLimit(1)

              VStack(alignment: .leading) {
              // MARK: - Movie title
                HStack {
                  Text(tvSeries.name ?? "Unknown")
                    .font(.title)
                    .textSelection(.enabled)

                  if let date = tvSeries.firstAirDate {
                    Text("(\(Calendar.current.component(.year, from: date).description))")
                  }
                }

                // MARK: - Tagline
                if let tagline = tvSeries.tagline, !tagline.isEmpty {
                  Text(tagline)
                    .font(.subheadline)
                    .italic()

                  Spacer(minLength: 16)
                }

                // MARK: - Overview
                Text(tvSeries.overview)

                Spacer(minLength: 16)

                // MARK: - Directed by
                Text(
                  "Created by \(Utilities.parseNamesList(tvSeries.createdBy.map { $0.name ?? "Unknown" }))"
                )
                .lineLimit(0)
                .bold()
              }
              // MARK: - Videos
              Text("Videos")
                .font(.title2)
              MovieVideosRowView(videos: tvSeries.videos)

              // MARK: - Cast
              Text("Cast")
                .font(.title2)
              TvSeriesCastRowView(cast: tvSeries.aggregateCredits.cast)
            }
            .padding()
          }
        } else if let error = vm.errorMessage {
          Text("Error: Film not loaded: \(error)")
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
  let personRepository = PersonRepositoryImpl(datasource: JsonPersonRemoteDatasource())
  TvSeriesDetailView(
    repository: TvSeriesRepositoryImpl(
      datasource: JsonTvSeriesDatasource()
    ),
    seriesId: 44217
  )
  .environment(personRepository)
}
