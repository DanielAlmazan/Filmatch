//
//  DiscoverMoviesViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

@Observable
final class DiscoverMoviesViewModel {
    var currentPage: Int = 1
    var movies: [DiscoverMoviesItem]?
    var isLoading: Bool
    var errorMessage: String?
    // TODO: Add filters
    
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
        self.movies = []
        self.isLoading = false
        self.currentPage = currentPage
    }
    
    @MainActor
    func discoverMovies(withQueryParams queryParams: [URLQueryItem]) {
        self.errorMessage = nil
        self.isLoading = true
        
        var movies: [DiscoverMoviesItem] = []
        
        Task {
            do {
                movies = try await repository.discoverMovies(withQueryParams: queryParams)
                self.movies?.append(contentsOf: movies)
            } catch {
                self.errorMessage = "Error discovering movies: \(error)"
                print(self.errorMessage!)
            }
        }
        
        self.isLoading = false
    }
}
