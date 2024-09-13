//
//  FilmResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 18/8/24.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let results: [MovieDetailSingleResponse]
}
