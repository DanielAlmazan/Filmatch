//
//  ProvidersView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 11/1/25.
//

import Kingfisher
import SwiftUI

struct ProvidersView: View {
  let providers: WatchProvidersResponse
  private let cornerRadius: CGFloat = 18
  private let maxWidth: CGFloat = 70

  private let providersGridRows: [GridItem] = [
    GridItem(),
  ]
  
  var body: some View {
    VStack {
      Text("Watch on...")
        .zIndex(1)
        .frame(maxWidth: .infinity, alignment: .bottom)
        .padding()
        .background(.thinMaterial)

      ScrollView {
        VStack(spacing: 20) {
          VStack {
            if let flatrate = providers.results?.flatrate {
              Text("Flatrate")
              ProvidersRow(providers: flatrate, maxWidth: maxWidth)
            }
          }
          
          VStack {
            if let buy = providers.results?.buy {
              Text("Buy")
              ProvidersRow(providers: buy, maxWidth: maxWidth)
            }
          }
          
          VStack {
            if let rent = providers.results?.rent {
              Text("Rent")
              ProvidersRow(providers: rent, maxWidth: maxWidth)
            }
          }
        }
      }
      .padding()
      .scrollClipDisabled()
      
      HStack {
        Text("Powered by JustWatch")
        Image(.justWatchLogo)
      }
      .frame(maxWidth: .infinity, alignment: .bottom)
      .padding()
      .background(.thinMaterial)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    .presentationDetents([.fraction(0.45)])
  }
}

#Preview("Raw View") {
  ProvidersView(providers: .default)
}

#Preview("Example Sheet") {
  @Previewable @State var isPresented: Bool = true
  
  VStack {
    Button("Open Providers View") {
      isPresented = true
    }
  }
  .sheet(isPresented: $isPresented) {
    ProvidersView(providers: .default)
  }
}

#Preview("On MovieDetails") {
  @Previewable @State var isPresented: Bool = true
  @Previewable @State var personRepository = PersonRepositoryImpl(datasource: JsonPersonRemoteDatasource())
  @Previewable @State var moviesRepository = MoviesRepositoryImpl(datasource: JsonMoviesRemoteDatasource())
  @Previewable let alienFilmId = 945961

  MovieDetailView(
    repository: moviesRepository,
    movieId: alienFilmId
  )
  .environment(personRepository)
  .environment(moviesRepository)
  .sheet(isPresented: $isPresented) {
    ProvidersView(providers: .default)
  }
}
