//
//  ContentView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import SwiftUI

struct ContentView: View {
    let alienFilmId = 945961
    let screamFilmId = 646385

    var body: some View {
        MovieDetailView(repository: TMDBRepository(), filmId: screamFilmId)
//        DiscoverMoviesView(repository: TMDBRepository())
    }
}

#Preview {
    ContentView()
}
