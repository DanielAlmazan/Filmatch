//
//  MovieCreditsViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

final class MovieCreditsViewModel: ObservableObject {
    @Published var credits: MovieCredits?
    @Published var areCreditsLoading: Bool
    @Published var errorMessage: String?
    
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
        self.areCreditsLoading = true
    }
    
    @MainActor
    func loadMovieCredits(forMovie id: Int) {
        self.errorMessage = nil
        
        Task {
            do {
                self.credits = try await repository.getMovieCredits(id: id)
            } catch {
                print("Error loading credits for movie ID \"\(id)\": \(error)")
                
                self.errorMessage = "Error loading credits for movie ID: \"\(id)\": \(error.localizedDescription)"
                
                if credits?.cast == nil {
                    self.errorMessage! += "\n - Cast is nil"
                }
                
                if credits?.crew == nil {
                    self.errorMessage! += "\n - Crew is nil"
                }
            }
        }
        
        self.areCreditsLoading = false
    }
}
