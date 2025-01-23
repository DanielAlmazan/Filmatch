//
//  FiltersView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 10/12/24.
//

import SwiftUI

struct FiltersView: View {
  @State var vm: FiltersViewModel

  let rows = [
    GridItem(),
    GridItem(),
  ]
  
  var isMovieSelected: Bool { vm.selectedMedia == .movie }
  var providers: [FiltersStreamingProviderSingleResponse] {
    isMovieSelected ? vm.movieProviders : vm.tvProviders
  }
  var genres: [Genre] {
    isMovieSelected ? vm.movieGenres : vm.tvGenres
  }

  init(filtersViewModel: FiltersViewModel) {
    self.vm = filtersViewModel
  }

  var body: some View {
    Form {
      Text("Select Filters")
        .font(.largeTitle)
        .bold()

      Section("What do you want to watch?") {
        HStack(spacing: 20) {
          Group {
            FilterToggleView(text: "Movie", isActive: vm.selectedMedia == .movie) {
              vm.selectedMedia = .movie
            }

            FilterToggleView(
              text: "TV Series", isActive: vm.selectedMedia == .tvSeries
            ) {
              vm.selectedMedia = .tvSeries
            }
          }
        }
        .buttonStyle(.borderless)
        .containerRelativeFrame(.horizontal)
      }

      Section("Genres") {
        if self.vm.selectedMedia == .movie && self.vm.areMovieGenresLoading ||
            self.vm.areTvGenresLoading {
          ProgressView()
        } else {
          ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 16) {
              ForEach(genres) { genre in
                FilterToggleView(
                  text: genre.name,
                  isActive: vm.isGenreSelected(genre)
                ) {
                  vm.onGenreSelectionChanged(genre)
                }
              }
            }
          }
          .scrollClipDisabled()
        }
      }

      Section("Platforms") {
        if self.vm.selectedMedia == .movie && self.vm.areMovieProvidersLoading ||
            self.vm.areTvProvidersLoading {
          ProgressView()
        } else {
          ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 16) {
              FilterToggleView(
                text: "All",
                isSquared: true,
                isActive: vm.areAllProvidersSelected()
              ) {
                vm.toggleAllProviders()
              }
              
              ForEach(providers) { provider in
                VStack {
                  FilterToggleView(
                    image: provider.logoPath,
                    isActive: vm.isProviderSelected(provider)
                  ) {
                    vm.onProvidersSelectionChanged(provider)
                  }
                }
              }
            }
          }
          .scrollClipDisabled()
        }
      }
    }
    .task {
      self.vm.fetchFilters()
    }
  }
}

#Preview {
  VStack {
  }.sheet(isPresented: .constant(true)) {
    FiltersView(
      filtersViewModel: FiltersViewModel(
        filtersRepository: FiltersRepositoryImpl(
          filtersDatasource: JsonFiltersDatasource()
        )
      ))
  }
}
