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
  private let repository: MoviesRepository
  
  /// The view model that handles data fetching and state management.
  private let vm: PersonDetailViewModel
  
  /// The unique identifier of the person to display.
  let personId: Int
  
  /// State variable to control whether the biography is expanded.
  @State private var isBiographyExpanded: Bool = false
  
  /// Initializes a new `PersonDetailView` with a repository and a person ID.
  /// - Parameters:
  ///   - repository: The `MoviesRepository` used to fetch person data.
  ///   - personId: The unique identifier of the person.
  init(repository: MoviesRepository = TMDBRepository(), personId: Int) {
    self.repository = repository
    self.vm = PersonDetailViewModel(repository: repository)
    self.personId = personId
  }
  
  /// Returns a localized string for "Known For Department" based on the person's gender.
  /// - Parameter person: The person whose details are being displayed.
  /// - Returns: A formatted localized string.
  private func knownForDepartmentStringResourceKey(person: PersonDetailSingleResponse) -> LocalizedStringResource {
    switch person.gender {
      case .female: "known_for_department_female: \(person.knownForDepartment)"
      case .male: "known_for_department_male: \(person.knownForDepartment)"
      case .notSet, .nonBinary: "known_for_department_non_binary: \(person.knownForDepartment)"
    }
  }
  
  /// Returns a localized string for "Also Known As" based on the person's gender.
  /// - Parameter person: The person whose details are being displayed.
  /// - Returns: A formatted localized string.
  private func alsoKnownAsStringResourceKey(person: PersonDetailSingleResponse) -> LocalizedStringResource {
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
  /// - Returns: <#description#>
  private func bornStringResourceKey(gender: Gender, birthday: String) -> LocalizedStringResource {
    switch gender {
      case .female: "born_female: \(birthday)"
      case .male: "born_male: \(birthday)"
      case .notSet, .nonBinary: "born_non_binary: \(birthday)"
    }
  }
  
  var body: some View {
    VStack {
      if vm.isLoading {
        // Show a progress view while the data is loading.
        ProgressView("Loading...")
      } else if let person = vm.person {
        // Display the person's details when data is available.
        ScrollView {
          VStack(alignment: .center, spacing: 16) {
            // MARK: - Profile Image
            if let profilePath = person.profilePath {
              PosterView(imageUrl: profilePath, size: "w500")
            } else {
              Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 5)
            }
            
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
                
                Text(person.biography)
                  .font(.body)
                  .lineLimit(isBiographyExpanded ? nil : 3)
                  .animation(.easeInOut(duration: 0.3), value: isBiographyExpanded)

                // "Read more"/"Read less" button
                Button {
                  isBiographyExpanded.toggle()
                } label: {
                  Text("Read \(isBiographyExpanded ? LocalizedStringResource(stringLiteral: "less") : LocalizedStringResource(stringLiteral: "more"))")
                    .font(.caption)
                    .foregroundColor(.blue)
                }
                .tint(.accent)
              }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
            } // Biography
            
            // MARK: - Additional Information
            VStack(alignment: .leading, spacing: 4) {
              if let birthday = person.birthday, !birthday.isEmpty {
                Text(bornStringResourceKey(gender: person.gender, birthday: birthday))
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
      } else {
        // Display an error message if the data failed to load.
        Text("Error: Person not loaded: \(vm.errorMessage ?? "Unknown error")")
      }
    }
    .ignoresSafeArea(edges: .top)
    .task {
      // Load the person data when the view appears.
      vm.loadPerson(byId: personId)
    }
  }
}

#Preview {
  PersonDetailView(
    repository: JsonPresetRepository(),
    personId: CastMember.default.id
  )
}
