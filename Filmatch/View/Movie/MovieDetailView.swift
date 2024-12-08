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
  init(repository: MoviesRepository = TMDBRepository(), filmId: Int) {
    self.repository = repository
    vm = MovieDetailViewModel(repository: repository)

    self.movieId = filmId
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
                VotesAverageCircleView(averageVotes: movie.voteAverage / 10)
                
                // MARK: - Genres
                if let genres = movie.genres, !(movie.genres?.isEmpty ?? false) {
                  Text(parseNamesList(genres.map { $0.name }))
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
                Text(movie.title)
                  .font(.title)
                
                // MARK: - Tagline
                if !movie.tagline.isEmpty {
                  Text(movie.tagline)
                    .font(.subheadline)
                    .italic()
                  
                  Spacer(minLength: 16)
                }
                
                // MARK: - Overview
                Text(movie.overview)
                
                Spacer(minLength: 16)
                
                // MARK: - Directed by
                Text(
                  "Directed by \(parseNamesList(movie.credits.crew?.filter { $0.job == "Director" }.map { $0.name }))"
                )
                .lineLimit(0)
                .bold()
              }
              
              // MARK: - Videos
              Text("Videos")
                .font(.title2)
              if let videos = movie.videos {
                MovieVideosRowView(videos: videos.results)
              }
              
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
  func minutesToHoursAndMinutes(minutes: Int) -> LocalizedStringResource {
    "\(minutes / 60)h \(minutes % 60)m"
  }

  /// Parses a list of names into a human-readable string.
  /// - Parameter names: An array of names.
  /// - Returns: A formatted string of names separated by commas and "and" before the last name.
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

// Use the movie id's to preview these films. They can be loaded
// either from the json presets or the TMDB repository
#Preview {
  @Previewable @State var alienFilmId = 945961
  @Previewable @State var screamFilmId = 646385
  @Previewable @State var jokerFilmId = 475557

  MovieDetailView(
//    repository: TMDBRepository(),
    repository: TMDBRepository(remoteDatasource: JsonMoviesRemoteDatasource()),
    filmId: alienFilmId
  )
}
