//
//  SearchMediaView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/1/25.
//

import Kingfisher
import SwiftUI

struct SearchMediaView: View {
  private enum ListType {
    case grid
    case list
  }

  @State private var searchVm: SearchViewModel

  @State private var isGridSelected: Bool = true

  @FocusState var isInputActive: Bool

  private var moviesRepository: MoviesRepository
  private var tvSeriesRepository: TvSeriesRepository

  let formatter = DateFormatter()

  init(
    moviesRepository: MoviesRepository,
    tvSeriesRepository: TvSeriesRepository
  ) {
    self.moviesRepository = moviesRepository
    self.tvSeriesRepository = tvSeriesRepository

    self.searchVm = .init(
      moviesRepository: moviesRepository,
      tvSeriesRepository: tvSeriesRepository)

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
      if !results.isEmpty {
        ScrollView {
          Group {
            if isGridSelected {
              SimpleMediaItemsGridView(results: results) {
                searchVm.search()
              }
            } else {
              SimpleMediaItemListView(results: results) {
                searchVm.search()
              }
            }
          }
          .lineLimit(1)
          .padding(.horizontal)
        }
      }
    }  // VStack
    .frame(maxHeight: .infinity, alignment: .top)
    .navigationTitle("Search")
    .navigationBarTitleDisplayMode(.inline)

    if searchVm.isLoading {
      ProgressView("Searching results for: \"\(searchVm.query)\"...")
    }
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
  
  NavigationStack {
    SearchMediaView(
      moviesRepository: moviesRepository,
      tvSeriesRepository: tvSeriesRepository
    )
  }
  .environment(moviesRepository)
  .environment(tvSeriesRepository)
  .environment(personRepository)
}
