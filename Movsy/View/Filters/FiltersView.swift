//
//  FiltersView.swift
//  Movsy
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
            FilterToggleView(
              localizedText: "Movies", isActive: vm.selectedMedia == .movie
            ) {
              vm.selectedMedia = .movie
            }

            FilterToggleView(
              localizedText: "TV Series", isActive: vm.selectedMedia == .tvSeries
            ) {
              vm.selectedMedia = .tvSeries
            }
          }
        }
        .containerRelativeFrame(.horizontal)
      }

      Section("Genres") {
        if self.vm.selectedMedia == .movie && self.vm.areMovieGenresLoading
          || self.vm.areTvGenresLoading
        {
          ProgressView()
        } else {
          ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 16) {
              ForEach(self.vm.genres) { genre in
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
        if self.vm.selectedMedia == .movie && self.vm.areMovieProvidersLoading
          || self.vm.areTvProvidersLoading
        {
          ProgressView()
        } else {
          ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 16) {
              FilterToggleView(
                localizedText: "all_filters",
                isSquared: true,
                isActive: vm.areAllProvidersSelected()
              ) {
                vm.toggleAllProviders()
              }

              ForEach(self.vm.providers) { provider in
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
      }  // Section Platforms

      Section("Year") {
        HStack {
          Picker("From", selection: self.$vm.selectedFilters.from) {
            ForEach(self.vm.selectedFilters.fromRange, id: \.self) { year in
              Text(String(year))
            }
          }
          .pickerStyle(.menu)

          Picker("To", selection: self.$vm.selectedFilters.to) {
            ForEach(self.vm.selectedFilters.toRange, id: \.self) { year in
              Text(String(year))
            }
          }
          .pickerStyle(.menu)
        }  // From / To Selectors HStack
      }  // Section Year

      Section("and more...") {
        HStack {
          VStack {
            FilterToggleView(
              localizedText: "Score > 50",
              isActive: self.vm.selectedFilters.minRating == .gte50
            ) {
              self.vm.selectedFilters.minRating =
                self.vm.selectedFilters.minRating == .gte50 ? nil : .gte50
            }
            FilterToggleView(
              localizedText: "Score > 75",
              isActive: self.vm.selectedFilters.minRating == .gte75
            ) {
              self.vm.selectedFilters.minRating =
                self.vm.selectedFilters.minRating == .gte75 ? nil : .gte75
            }
          }

          VStack {
            FilterToggleView(
              localizedText: "< 95 min",
              isActive: self.vm.selectedFilters.maxRuntime == .lte95
            ) {
              self.vm.selectedFilters.maxRuntime =
                self.vm.selectedFilters.maxRuntime == .lte95 ? nil : .lte95
            }
            FilterToggleView(
              localizedText: "< 120 min",
              isActive: self.vm.selectedFilters.maxRuntime == .lte120
            ) {
              self.vm.selectedFilters.maxRuntime =
                self.vm.selectedFilters.maxRuntime == .lte120 ? nil : .lte120
            }
          }
        }
      }
    }
    .buttonStyle(.borderless)
  }
}

#Preview {
  @Previewable @State var vm = FiltersViewModel(
    filtersRepository: FiltersRepositoryImpl(
      filtersDatasource: JsonFiltersDatasource()
    )
  )
  VStack {
  }.sheet(isPresented: .constant(true)) {
    FiltersView(
      filtersViewModel: vm)
  }
  .task {
    vm.fetchFilters()
  }
  .environment(\.locale, .init(identifier: "es"))
}
