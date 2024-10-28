//
//  MovieDetailView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import SwiftUI

/// `MovieDetailView` is a SwiftUI view that displays detailed information about a movie.
/// It includes the movie's poster, title, genres, runtime, overview, director, cast, and videos.
/// The view fetches movie data from a provided repository using a view model.
struct MovieDetailView: View {
  /// The repository used to fetch movie data.
  private let repository: MoviesRepository
  
  /// The view model that handles data fetching and state management.
  private let vm: MovieDetailViewModel

  /// The unique identifier of the movie to display.
  let movieId: Int

  /// Initializes a new `MovieDetailView` with a repository and a movie ID.
  /// - Parameters:
  ///   - repository: The `MoviesRepository` used to fetch movie data.
  ///   - filmId: The unique identifier of the movie.
  // TODO: Implement preloadedMovie: DiscoverMoviesItem to show some data earlier
  init(repository: MoviesRepository = MoviesRepository(), filmId: Int) {
    self.repository = repository
    vm = MovieDetailViewModel(repository: repository)

    self.movieId = filmId
  }

  var body: some View {
    ScrollView {
      if vm.isMovieLoading {
        ProgressView("Loading...")
      } else if let movie = vm.movie {
        PosterView(imageUrl: movie.posterPath, size: "w500")
        VStack(alignment: .leading, spacing: 16) {
          HStack {
            VotesAverageCircleView(
              averageVotes: movie.voteAverage / 10, lineWidth: 5
            )
            .frame(width: 36)

            if let genres = movie.genres, !(movie.genres?.isEmpty ?? false) {
              Text(parseNamesList(genres.map { $0.name }))
                .font(.subheadline)
            }

            Spacer()

            Image(systemName: "clock")
            Text(minutesToHoursAndMinutes(minutes: movie.runtime))
              .font(.footnote)
          }

          VStack(alignment: .leading) {
            Text(movie.title)
              .font(.title)

            if !movie.tagline.isEmpty {
              Text(movie.tagline)
                .font(.subheadline)
                .italic()

              Spacer(minLength: 16)
            }

            Text(movie.overview)

            Spacer(minLength: 16)

            Text(
              "Directed by \(parseNamesList(movie.credits.crew?.filter { $0.job == "Director" }.map { $0.name }))"
            )

            .lineLimit(0)
            .bold()
          }

          Text("Videos")
            .font(.title2)
          MovieVideosRowView(videos: movie.videos.results)

          Spacer(minLength: 16)

          Text("Cast")
            .font(.title2)
          MovieCastRowView(cast: movie.credits.cast)
        }
        .padding()

      } else {
        Text("Error: Film not loaded: \(vm.errorMessage ?? "Unknown error")")
      }
    }
    .onAppear {
      vm.loadMovie(byId: movieId)
    }
    .ignoresSafeArea(edges: .top)
  }

  func minutesToHoursAndMinutes(minutes: Int) -> LocalizedStringResource {
    "\(minutes / 60)h \(minutes % 60)m"
  }

  func parseNamesList(_ names: [String]?) -> LocalizedStringResource {
    guard let names = names, !names.isEmpty else { return "Unknown" }

    if names.count == 1 {
      return "\(names.first!)"
    } else {
      let allButLast = names.prefix(upTo: names.count - 1)

      return "\(allButLast.joined(separator: ", ")) and \(names.last!)"
    }
  }
}

#Preview {
  @Previewable @State var alienFilmId = 945961
  @Previewable @State var screamFilmId = 646385

  return MovieDetailView(
    repository: JsonPresetRepository(), filmId: screamFilmId)
}
