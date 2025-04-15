//
//  SearchMediaView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 17/1/25.
//

import Kingfisher
import SwiftUI

struct SearchMediaView: View {
  @State private var searchVm: SearchViewModel

  @State private var isGridSelected: Bool = true

  @FocusState var isInputActive: Bool

  private var moviesRepository: MoviesRepository
  private var tvSeriesRepository: TvSeriesRepository
  private var movsyRepository: MovsyGoRepository

  let formatter = DateFormatter()

  init(
    moviesRepository: MoviesRepository,
    tvSeriesRepository: TvSeriesRepository,
    movsyRepository: MovsyGoRepository
  ) {
    self.moviesRepository = moviesRepository
    self.tvSeriesRepository = tvSeriesRepository
    self.movsyRepository = movsyRepository

    self.searchVm = .init(
      moviesRepository: moviesRepository,
      tvSeriesRepository: tvSeriesRepository,
      movsyRepository: movsyRepository)

    formatter.dateFormat = "yyyy"
  }

  var body: some View {
    VStack {
      // MARK: - Movies / TV Selector
      MediaSelector(selectedMedia: $searchVm.selectedMedia)
      
      // MARK: - Search Field and View Mode toggle
      HStack {
        SearchField(query: $searchVm.query, onSubmit: { searchVm.search() })
        GridSelectorButton(isGridSelected: $isGridSelected)
      }
      .padding()
      
      if let error = self.searchVm.errorMessage {
        Text(error)
          .foregroundColor(.red)
          .padding()
      }

      // MARK: - Results
      let results = self.searchVm.currentResults
      if !(results?.isEmpty ?? true) {
        ScrollView {
          Group {
            if isGridSelected {
              SimpleMediaItemsGridView(
                results: self.$searchVm.currentResults,
                updateItem: updateItem,
                onLastAppeared: search
              )
            } else {
              SimpleMediaItemListView(
                results: self.$searchVm.currentResults,
                updateItem: updateItem,
                onLastAppeared: search
              )
            }
          }
          .lineLimit(1)
          .padding(.horizontal)
        }
      }
    }  // VStack
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle("Search")

    if searchVm.isLoading {
      ProgressView("Searching results for: \"\(searchVm.query)\"...")
    }
  }

  private func updateItem(_ item: any DiscoverItem, _ interestStatus: InterestStatus?) {
    guard let interestStatus else { return }
    Task {
      await searchVm.updateItem(item, for: interestStatus)
    }
  }

  private func search() {
    searchVm.search()
  }
}

#Preview {
  @Previewable @State var moviesRepository = MoviesRepositoryImpl(
//      remoteDatasource: JsonMoviesRemoteDatasource()
    datasource: MoviesRemoteDatasourceImpl(client: TMDBHttpClient())
  )
  @Previewable @State var tvSeriesRepository = TvSeriesRepositoryImpl(
//      remoteDatasource: JsonTvSeriesDatasource()
    datasource: TvSeriesDatasourceImpl(client: TMDBHttpClient())
  )
  @Previewable @State var personRepository = PersonRepositoryImpl(
    datasource: PersonDatasourceImpl(client: TMDBHttpClient())
  )
  @Previewable @State var movsyRepository = MovsyGoRepositoryImpl(datasource: JsonMovsyDatasource(client: TMDBJsonClient()))

  NavigationStack {
    SearchMediaView(
      moviesRepository: moviesRepository,
      tvSeriesRepository: tvSeriesRepository,
      movsyRepository: movsyRepository
    )
  }
  .environment(moviesRepository)
  .environment(tvSeriesRepository)
  .environment(personRepository)
}
