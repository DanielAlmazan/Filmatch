//
//  MoviesSearchResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import Foundation

final class MoviesSearchResponse: Codable {
    let page: Int
    let results: [MovieSearchResultSingleResponse]
    let totalPages: Int
    let totalResults: Int
    
    init(page: Int, results: [MovieSearchResultSingleResponse], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
