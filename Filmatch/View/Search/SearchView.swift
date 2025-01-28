//
//  SearchView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 17/1/25.
//

import Kingfisher
import SwiftUI

struct SearchView: View {
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
      HStack(spacing: 10) {
        Image(systemName: "magnifyingglass").opacity(0.50)

        // MARK: - TextField
        TextField("Search", text: $searchVm.query)
          .submitLabel(.search)
          .scrollDismissesKeyboard(.immediately)
          .focused($isInputActive)

          .onSubmit {
            self.searchVm.search()
          }
          .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
              Spacer()

              Button("Hide Keyboard", role: .destructive) {
                isInputActive = false
              }
            }
          }

        // MARK: - Clear Button
        if !searchVm.query.isEmpty {
          // Button to clear the text field.
          Button {
            searchVm.query.removeAll()
          } label: {
            Image(systemName: "multiply.circle.fill")
              .symbolEffect(.bounce, options: .nonRepeating)
          }
        }
      }  // HStack Field
      .frame(height: 25)
      .padding(5)
      .background(.bgContainer)
      .clipShape(.rect(cornerRadius: 8))
      .padding()

      // MARK: - Movies / TV Selector and View Mode toggle
      HStack(spacing: 20) {
        FilterToggleView(
          text: "Movie", isActive: searchVm.selectedMedia == .movie
        ) {
          searchVm.selectedMedia = .movie
        }

        FilterToggleView(
          text: "TV Series", isActive: searchVm.selectedMedia == .tvSeries
        ) {
          searchVm.selectedMedia = .tvSeries
        }

        Button {
          isGridSelected.toggle()
        } label: {
          Image(systemName: isGridSelected ? "square.grid.2x2.fill" : "list.bullet")
        }
        .frame(width: 24, height: 24)
        .symbolEffect(.bounce, options: .nonRepeating, value: isGridSelected)
      }
      .buttonStyle(.borderless)
      .containerRelativeFrame(.horizontal)  // Movies / TV Selector

      if let error = self.searchVm.errorMessage {
        Text(error)
          .foregroundColor(.red)
          .padding()
      }

      // MARK: - Results
      let results = self.searchVm.currentResults
      if !results.isEmpty {
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
        .padding()
      }
    }  // VStack
    .navigationTitle("Search")
    .navigationBarTitleDisplayMode(.inline)
    .frame(maxHeight: .infinity, alignment: .top)

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
    SearchView(
      moviesRepository: moviesRepository,
      tvSeriesRepository: tvSeriesRepository
    )
  }
  .environment(moviesRepository)
  .environment(tvSeriesRepository)
  .environment(personRepository)
}
