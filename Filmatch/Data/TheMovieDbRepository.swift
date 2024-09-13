//
//  FilmRepositoryImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 16/8/24.
//

import Foundation

final class TMDBRepository: Repository {
    internal var urlBase: String = "https://api.themoviedb.org/3"
    
    private let apiKey: String = Config.shared.apiKey
    private let accessTokenAuth: String = Config.shared.accessTokenAuth
    private var queryItems: [URLQueryItem]

    init() {
        let language = "\(Locale.preferredLanguages.first ?? "en-US")"
        
        queryItems = [
            URLQueryItem(name: "language", value: "\(language)"),
            URLQueryItem(name: "api_key", value: "\(apiKey)"),
        ]
    }
    
    func getMovie(byId id: Int) async throws -> MovieDetailSingleResponse? {
        let url = URL(string: "\(urlBase)/movie/\(id)")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        queryItems.append(contentsOf: [
            URLQueryItem(name: "append_to_response", value: "videos,credits")
        ])
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethods.GET.rawValue
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
        ]
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        return try decoder.decode(MovieDetailSingleResponse.self, from: data)
    }
    
    func getProviders() async throws -> [MovieProvider] {
        []
    }
    
    func getMovieCredits(id: Int) async throws -> MovieCredits {
        let url = URL(string: "\(urlBase)/movie/\(id)/credits")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethods.GET.rawValue
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
        ]
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        return try decoder.decode(MovieCredits.self, from: data)
    }
    
    func discoverMovies(withQueryParams queryParams: [URLQueryItem]) async throws -> [DiscoverMoviesItem] {
        let url = URL(string: "\(urlBase)/discover/movie")!
        
        queryParams.forEach { item in
            self.queryItems.append(item)
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethods.GET.rawValue
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
        ]
        
        let (data, _) = try await URLSession.shared.data(for: request)

        let decoder = JSONDecoder()
        return try decoder.decode(DiscoverMoviesResponse.self, from: data).results
    }
    
    func searchMovies(_ query: String, includeAdult: Bool?, primaryReleaseDate: String?, page: Int?, region: String?, year: Int?) async throws -> [MoviesSearchResponse] {
        []
    }
    
    func getVideos(byMovieId id: Int) async throws -> MovieVideosResponse {
        let url = URL(string: "\(urlBase)/movie/\(id)/videos")!
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPMethods.GET.rawValue
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
        ]
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        return try decoder.decode(MovieVideosResponse.self, from: data)
    }
}
