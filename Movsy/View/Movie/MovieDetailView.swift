//
//  MovieDetailView.swift
//  Movsy
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
  
  @State private var showProviders: Bool = false
  
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
            PosterView(imageUrl: movie.posterPath, size: .w500, posterType: .movie)
            
            VStack(alignment: .leading, spacing: 16) {
              MovieFirstDetailsRow(
                voteAverage: movie.voteAverage, 
                genres: movie.genres, 
                runtime: movie.runtime, 
                providers: vm.providers)
              .lineLimit(1)

              VStack(alignment: .leading) {
                // MARK: - Movie title
                HStack {
                  Text(movie.title ?? "Unknown")
                    .font(.title)
                    .textSelection(.enabled)

                  if let date = movie.releaseDate {
                    Text("(\(Calendar.current.component(.year, from: date).description))")
                  }
                }

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
              
              // MARK: - Cast
              Text("Cast")
                .font(.title2)
              MovieCastRowView(cast: movie.credits.cast)
            }
            .padding()
          }
        } else if vm.errorMessage != nil {
          // Display an error message if the movie failed to load.
          Text("Error: Film not loaded")
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(.bgBase)
      .ignoresSafeArea(edges: .top)
      .task {
        // Load the movie data when the view appears.
        vm.loadMovie(byId: movieId)
        vm.loadProviders(forMovieId: movieId)
      }
    }  // VStack Base
  }
}

// Use the movie id's to preview these films. They can be loaded
// either from the json presets or the TMDB repository
#Preview("Alien: Romulus") {
  @Previewable @State var personRepository = PersonRepositoryImpl(datasource: JsonPersonRemoteDatasource())
  @Previewable @State var moviesRepository = MoviesRepositoryImpl(datasource: JsonMoviesRemoteDatasource())
  
  @Previewable let alienFilmId = 945961

  MovieDetailView(
    repository: moviesRepository,
    movieId: alienFilmId
  )
  .environment(personRepository)
  .environment(moviesRepository)
}

#Preview("Scream") {
  @Previewable @State var personRepository = PersonRepositoryImpl(datasource: JsonPersonRemoteDatasource())
  @Previewable @State var moviesRepository = MoviesRepositoryImpl(datasource: JsonMoviesRemoteDatasource())
  
  @Previewable let screamFilmId = 646385

  MovieDetailView(
    repository: moviesRepository,
    movieId: screamFilmId
  )
  .environment(personRepository)
  .environment(moviesRepository)
}

#Preview("Joker") {
  @Previewable @State var personRepository = PersonRepositoryImpl(datasource: JsonPersonRemoteDatasource())
  @Previewable @State var moviesRepository = MoviesRepositoryImpl(datasource: JsonMoviesRemoteDatasource())
  
  @Previewable let jokerFilmId = 475557

  MovieDetailView(
    repository: moviesRepository,
    movieId: jokerFilmId
  )
  .environment(personRepository)
  .environment(moviesRepository)
}
