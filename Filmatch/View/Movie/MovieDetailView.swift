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
  /// The view model that handles data fetching and state management.
  @State private var vm: MovieDetailViewModel

  /// The unique identifier of the movie to display.
  let movieId: Int

  /// Initializes a new `MovieDetailView` with a repository and a movie ID.
  /// - Parameters:
  ///   - repository: The `MoviesRepository` used to fetch movie data.
  ///   - filmId: The unique identifier of the movie.
  // TODO: Implement preloadedMovie: DiscoverMoviesItem to show some data earlier
  init(repository: MoviesRepository, movieId: Int) {
    vm = .init(repository: repository)

    self.movieId = movieId
  }

  var body: some View {
    NavigationStack {
      VStack {
        if vm.isMovieLoading {
          // Show a progress view while the movie data is loading.
          ProgressView("Loading...")
        } else if let movie = vm.movie {
          // Display the movie details when data is available.
          ScrollView {
            // MARK: - Poster Image
            PosterView(imageUrl: movie.posterPath, size: "w500")
            
            VStack(alignment: .leading, spacing: 16) {
              HStack {
                // MARK: - Average vote
                VotesAverageCircleView(averageVotes: movie.voteAverage)
                
                // MARK: - Genres
                if !movie.genres.isEmpty {
                  Text(Utilities.parseNamesList(movie.genres.map { $0.name ?? "nil" }))
                    .font(.subheadline)
                }
                
                Spacer()
                
                // MARK: - Runtime
                Image(systemName: "clock")
                Text(minutesToHoursAndMinutes(minutes: movie.runtime))
                  .font(.footnote)
              }
              
              VStack(alignment: .leading) {
                // MARK: - Movie title
                Text(movie.title ?? "Unknown")
                  .font(.title)
                
                // MARK: - Tagline
                if let tagline = movie.tagline, !tagline.isEmpty {
                  Text(tagline)
                    .font(.subheadline)
                    .italic()
                  
                  Spacer(minLength: 16)
                }
                
                // MARK: - Overview
                Text(movie.overview)
                
                Spacer(minLength: 16)
                
                // MARK: - Directed by
                Text(
                  "Directed by \(Utilities.parseNamesList(movie.credits.crew?.filter { $0.job == "Director" }.map { $0.name }))"
                )
                .lineLimit(0)
                .bold()
              }
              
              // MARK: - Videos
              Text("Videos")
                .font(.title2)
              MovieVideosRowView(videos: movie.videos.results)
              
              Spacer(minLength: 16)
              
              // MARK: - Cast
              Text("Cast")
                .font(.title2)
              MovieCastRowView(cast: movie.credits.cast)
            }
            .padding()
          }
          
        } else {
          // Display an error message if the movie failed to load.
          Text("Error: Film not loaded: \(vm.errorMessage ?? "Unknown error")")
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.bgBase)
      .ignoresSafeArea(edges: .top)
      .task {
        // Load the movie data when the view appears.
        vm.loadMovie(byId: movieId)
      }
    }  // VStack Base
  }

  /// Converts minutes into a formatted string of hours and minutes.
  /// - Parameter minutes: The total minutes to convert.
  /// - Returns: A formatted string representing hours and minutes (e.g., "2h 15m").
  private func minutesToHoursAndMinutes(minutes: Int?) -> LocalizedStringResource {
    guard let minutes else { return "Unknown" }
    return minutes == 0 ? "Unknown" : "\(minutes / 60)h \(minutes % 60)m"
  }
}

// Use the movie id's to preview these films. They can be loaded
// either from the json presets or the TMDB repository
#Preview {
  @Previewable @State var alienFilmId = 945961
  @Previewable @State var screamFilmId = 646385
  @Previewable @State var jokerFilmId = 475557
  @Previewable @State var personRepository = PersonRepositoryImpl(datasource: JsonPersonRemoteDatasource())

  MovieDetailView(
    repository: MoviesRepositoryImpl(
      remoteDatasource: JsonMoviesRemoteDatasource()
    ),
    movieId: alienFilmId
  )
  .environment(personRepository)
}
