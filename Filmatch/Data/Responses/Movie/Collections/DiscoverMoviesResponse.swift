//
//  DiscoverMoviesResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/8/24.
//

import Foundation

final class DiscoverMoviesResponse: Codable {
    let page: Int
    let results: [DiscoverMoviesItem]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
