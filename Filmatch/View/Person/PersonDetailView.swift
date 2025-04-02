//
//  PersonDetailView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 7/9/24.
//

import SwiftUI

/// `PersonDetailView` displays detailed information about a person, such as an actor or director.
/// It includes the person's profile image, name, biography, and other relevant information.
struct PersonDetailView: View {
  /// The repository used to fetch person data.
  //  private let repository: PersonRepository

  /// The view model that handles data fetching and state management.
  private let personVm: PersonDetailViewModel

  /// The unique identifier of the person to display.
  let personId: Int

  @Environment(MoviesRepositoryImpl.self) var moviesRepository

  /// Initializes a new `PersonDetailView` with a repository and a person ID.
  /// - Parameters:
  ///   - repository: The `MoviesRepository` used to fetch person data.
  ///   - personId: The unique identifier of the person.
  init(repository: PersonRepository, personId: Int) {
    self.personVm = PersonDetailViewModel(repository: repository)
    self.personId = personId
  }

  /// Returns a localized string for "Known For Department" based on the person's gender.
  /// - Parameter person: The person whose details are being displayed.
  /// - Returns: A formatted localized string.
  private func knownForDepartmentStringResourceKey(
    person: PersonDetailSingleResponse
  ) -> LocalizedStringResource {
    switch person.gender {
    case .female: "known_for_department_female: \(person.knownForDepartment)"
    case .male: "known_for_department_male: \(person.knownForDepartment)"
    case .notSet, .nonBinary:
      "known_for_department_non_binary: \(person.knownForDepartment)"
    }
  }

  /// Returns a localized string for "Also Known As" based on the person's gender.
  /// - Parameter person: The person whose details are being displayed.
  /// - Returns: A formatted localized string.
  private func alsoKnownAsStringResourceKey(person: PersonDetailSingleResponse)
    -> LocalizedStringResource
  {
    let names = person.alsoKnownAs.joined(separator: ", ")
    return switch person.gender {
    case .female: "also_known_as_female: \(names)"
    case .male: "also_known_as_male: \(names)"
    case .notSet, .nonBinary: "also_known_as_non_binary: \(names)"
    }
  }

  /// Returns a localized string for "Born" based on the person's gender.
  /// - Parameters:
  ///   - person: The person whose details are being displayed.
  ///   - birthday: The birthday that is being displayed
  /// - Returns: LocalizedStringResource
  private func bornStringResourceKey(gender: Gender, birthday: Date)
    -> LocalizedStringResource
  {
    let dateFormatter = DateFormatter()
    let locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.locale = locale
    dateFormatter.dateFormat = "MMMM dd, yyyy"
    let birthdayString = dateFormatter.string(from: birthday)
    return switch gender {
    case .female: "born_female: \(birthdayString)"
    case .male: "born_male: \(birthdayString)"
    case .notSet, .nonBinary: "born_non_binary: \(birthdayString)"
    }
  }

  let gridRows: [GridItem] = [
    GridItem()
  ]

  var body: some View {
    VStack {
      if personVm.isLoading {
        // Show a progress view while the data is loading.
        ProgressView("Loading...")
      } else if let person = personVm.person {
        // Display the person's details when data is available.
        ScrollView {
          VStack(alignment: .center, spacing: 16) {
            // MARK: - Profile Image
            PosterView(
              imageUrl: person.profilePath, size: .w500, posterType: .person)

            // MARK: - Name
            Text(person.name)
              .font(.title)
              .bold()

            // MARK: - Known For Department
            if !person.knownForDepartment.isEmpty {
              Text(knownForDepartmentStringResourceKey(person: person))
                .font(.subheadline)
            }

            // MARK: - Biography
            if !person.biography.isEmpty {
              VStack(alignment: .leading, spacing: 8) {
                Text("Biography")
                  .font(.headline)

                ExpandableText(person.biography, lineLimit: 2)
              }
              .padding()
            }  // Biography

            // MARK: - Credits
            VStack {
              Text("Movies")
                .font(.title2)
              if let movies = person.movieCredits.cast {
                PersonMovieCreditsAsCastRow(movies: movies.sortedByOrderOrReleaseDate())
              }
              
              if let movies = person.movieCredits.crew {
                PersonMovieCreditsAsCrewRow(movies: movies.sortedByPopularityAndJob())
              }
              
              Text("Tv Series")
                .font(.title2)
              if let tvSeries = person.tvCredits.cast {
                PersonTvSeriesCreditsAsCastRow(tvSeries: tvSeries.sortedByPopularity())
              }
              
              if let tvSeries = person.tvCredits.crew {
                PersonTvSeriesCreditsAsCrewRow(tvSeries: tvSeries)
              }
            }

            // MARK: - Additional Information
            VStack(alignment: .leading, spacing: 8) {
              if let birthday = person.birthday {
                Text(
                  bornStringResourceKey(
                    gender: person.gender, birthday: birthday))
              }
              if let placeOfBirth = person.placeOfBirth, !placeOfBirth.isEmpty {
                Text("Place of Birth: \(placeOfBirth)")
              }
              if !person.alsoKnownAs.isEmpty {
                Text(alsoKnownAsStringResourceKey(person: person))
              }
            }
            .font(.footnote)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
          }
        }
      } else if let errorMessage = personVm.errorMessage {
        // Display an error message if the data failed to load.
        Text(
          "Error: Person not loaded: \(errorMessage)"
        )
      }
    }
    .ignoresSafeArea(edges: .top)
    .task {
      // Load the person data when the view appears.
      self.personVm.loadPerson(byId: personId)
    }
  }
}

#Preview {
  NavigationStack {
    PersonDetailView(
      repository: PersonRepositoryImpl(
        datasource: JsonPersonRemoteDatasource()
      ),
      personId: CastMember.default.id
    )
    .environment(
      MoviesRepositoryImpl(
        datasource: JsonMoviesRemoteDatasource()
      )
    )
    .environment(
      TvSeriesRepositoryImpl(
        datasource: JsonTvSeriesDatasource()
      )
    )
  }
}
