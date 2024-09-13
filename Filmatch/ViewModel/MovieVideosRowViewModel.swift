//
//  MovieVideosRowViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import Foundation

class MovieVideosRowViewModel: ObservableObject {
    @Published var videos: [Video]?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    @MainActor
    func loadVideos(byMovieId id: Int) {
        isLoading = true
        self.errorMessage = nil
        
        Task {
            do {
                self.videos = try await repository.getVideos(byMovieId: id).results
            } catch {
                self.errorMessage = "Failed to load videos of the movie with ID \(id)\n\(error.localizedDescription)"
            }
        }
        
        isLoading = false
    }
}
