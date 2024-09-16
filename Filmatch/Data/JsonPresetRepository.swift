//
//  DefaultDataSource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/9/24.
//

import Foundation

enum JsonPresetRepositoryError: String, Error {
    case notImplemented = "Function not implemented yet"
    case fileNotFound = "File not found"
    case decodingError = "Decoding error"
}

class JsonPresetRepository: Repository {
    func loadJson<T: Decodable>(filename: String, type: T.Type) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Error loading file \"\(filename)\"")
            throw JsonPresetRepositoryError.fileNotFound
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    func getMovie(byId id: Int) async throws -> MovieDetailSingleResponse? {
        return try loadJson(filename: "movie-\(id)-append_to_response-videos_credits", type: MovieDetailSingleResponse.self)
    }
    
    func getProviders() async throws -> [MovieProvider] {
        []
    }
    
    func getMovieCredits(id: Int) async throws -> MovieCredits {
        throw JsonPresetRepositoryError.notImplemented
    }
    
    func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async throws -> [DiscoverMoviesItem] {
        var page = 1
        
        if let pageParam = queryParams.first(where: { $0.name == "page" })?.value, let pageNumber = Int(pageParam) {
            page = pageNumber
        }
        
        let filename = "discover_movies-page\(page)"
        
        return try loadJson(filename: filename, type: DiscoverMoviesResponse.self).results
    }
    
    func searchMovies(_ query: String, includeAdult: Bool?, primaryReleaseDate: String?, page: Int?, region: String?, year: Int?) async throws -> [MoviesSearchResponse] {
        []
    }
    
    func getVideos(byMovieId id: Int) async throws -> MovieVideosResponse {
        throw JsonPresetRepositoryError.notImplemented
    }
}
