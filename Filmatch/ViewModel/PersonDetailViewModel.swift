//
//  PersonDetailViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 9/9/24.
//

import Foundation

/// `PersonDetailViewModel` handles fetching and storing detailed information about a person.
@Observable
final class PersonDetailViewModel {
  /// The person's detailed information.
  var person: PersonDetailSingleResponse?
  
  /// Indicates whether the data is currently being loaded.
  var isLoading: Bool
  
  /// An optional error message if an error occurs during data fetching.
  var errorMessage: String?
  
  /// The repository used to fetch person data.
  private let repository: MoviesRepository
  
  /// Initializes a new instance of `PersonDetailViewModel`.
  /// - Parameter repository: The `MoviesRepository` used to fetch person data.
  init(repository: MoviesRepository) {
    self.repository = repository
    self.isLoading = true
  }
  
  /// Loads the person's details by ID.
  /// - Parameter id: The unique identifier of the person to load.
  @MainActor
  func loadPerson(byId id: Int) {
    self.errorMessage = nil
    
    Task {
      let result = await repository.getPerson(byId: id)
      
      switch result {
        case .success(let person):
          self.person = person
        case .failure(let error):
          self.errorMessage = "Failed to load person with ID \"\(id)\"\n\(error.localizedDescription)"
          print("Error: \(error)")
      }

      self.isLoading = false
    }
  }
}
