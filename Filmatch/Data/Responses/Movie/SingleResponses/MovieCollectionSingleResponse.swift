//
//  FilmCollection.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

final class MovieCollectionSingleResponse: Identifiable, Codable {
    let id: Int
    let name: String
    let posterPath: String
    let backdropPath: String
    var movies: [MovieDetailSingleResponse] = []
    
    init(id: Int, name: String, poster_path: String, backdrop_path: String) {
        self.id = id
        self.name = name
        self.posterPath = poster_path
        self.backdropPath = backdrop_path
    }
}

extension MovieCollectionSingleResponse {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}
