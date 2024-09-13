//
//  Film.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

// MARK: Base
final class MovieDetailSingleResponse: Identifiable, Codable {
    let id: Int
    let adult: Bool
    let backdropPath: String
    let belongsToCollection: MovieCollectionSingleResponse?
    let budget: Int
    let genres: [Genre]?
    let homepage: String
    let imdbId: String
    let originCountry: [String]
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let productionCompanies: [ProductionCompany]
    let productionCountries: [Country]
    let releaseDate: String
    let revenue: Int
    let runtime: Int
    let spokenLanguages: [LanguageModel]
    let status: String
    let tagline: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let videos: MovieVideosAppendResponse
    let credits: MovieCreditsAppendResponse
    
    init(id: Int, adult: Bool, backdropPath: String, belongsToCollection: MovieCollectionSingleResponse?, budget: Int, genres: [Genre]?, homepage: String, imdbId: String, originCountry: [String], originalLanguage: String, originalTitle: String, overview: String, popularity: Double, posterPath: String, productionCompanies: [ProductionCompany], productionCountries: [Country], releaseDate: String, revenue: Int, runtime: Int, spokenLanguages: [LanguageModel], status: String, tagline: String, title: String, video: Bool, voteAverage: Double, voteCount: Int, videos: MovieVideosAppendResponse, credits: MovieCreditsAppendResponse) {
        self.id = id
        self.adult = adult
        self.backdropPath = backdropPath
        self.belongsToCollection = belongsToCollection
        self.budget = budget
        self.genres = genres
        self.homepage = homepage
        self.imdbId = imdbId
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.releaseDate = releaseDate
        self.revenue = revenue
        self.runtime = runtime
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.videos = videos
        self.credits = credits
    }
    
    // MARK: Decoder
    enum CodingKeys: String, CodingKey {
        case id, adult, budget, genres, overview, popularity, revenue, runtime, status, tagline, title, video, videos, credits
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case homepage = "homepage"
        case imdbId = "imdb_id"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case spokenLanguages = "spoken_languages"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: Description
extension MovieDetailSingleResponse: CustomStringConvertible {
    var description: String {
        let genreNames = genres?.map { $0.name }.joined(separator: ", ") ?? "No genres available"
        return """
        Movie:
        - Title: \(title)
        - Original Title: \(originalTitle)
        - Release Date: \(releaseDate)
        - Genres: \(genreNames)
        - Overview: \(overview)
        - Popularity: \(popularity)
        - Vote Average: \(voteAverage)
        - Vote Count: \(voteCount)
        - Runtime: \(runtime) minutes
        - Status: \(status)
        - Tagline: \(tagline)
        - Homepage: \(homepage)
        - IMDB ID: \(imdbId)
        """
    }
}

// MARK: Default Movie
//extension MovieDetailSingleResponse {
//    static let `default` = MovieDetailSingleResponse(
//        id: 646385,
//        adult: false,
//        backdropPath: "/ifUfE79O1raUwbaQRIB7XnFz5ZC.jpg",
//        belongsToCollection: MovieCollectionSingleResponse(
//            id: 2602,
//            name: "Scream Collection",
//            poster_path: "/p3EjClFy20jjT0u06dzBs4lvvhi.jpg",
//            backdrop_path: "/oUcscMECv8DOBsAPCh3KnDZqAC4.jpg"),
//        budget: 24000000,
//        genres: [
//            Genre(id: 27, name: "Horror"),
//            Genre(id: 9648, name: "Mistery"),
//            Genre(id: 53, name: "Thriller")
//        ],
//        homepage: "https://www.paramountmovies.com/movies/scream",
//        imdbId: "tt11245972",
//        originCountry: ["US"],
//        originalLanguage: "en",
//        originalTitle: "Scream",
//        overview: "Twenty-five years after a streak of brutal murders shocked the quiet town of Woodsboro, a new killer has donned the Ghostface mask and begins targeting a group of teenagers to resurrect secrets from the town’s deadly past.",
//        popularity: 77.675,
//        posterPath: "/1m3W6cpgwuIyjtg5nSnPx7yFkXW.jpg",
//        productionCompanies: [
//            ProductionCompany(
//                id: 4,
//                logoPath: "/gz66EfNoYPqHTYI4q9UEN4CbHRc.png",
//                name: "Paramount Pictures",
//                originCountry: "US"
//            ),
//            ProductionCompany(
//                id: 130448,
//                logoPath: "/yHWTTGKbOGZKUd1cp6l3uLyDeiv.png",
//                name: "Project X Entertainment",
//                originCountry: "US"
//            ),
//            ProductionCompany(
//                id: 126588,
//                logoPath: "/cNhOITS96oOV7SCgUHxvZlWRecx.png",
//                name: "Radio Silence",
//                originCountry: "US"
//            ),
//            ProductionCompany(
//                id: 143790,
//                logoPath: "/wo1smiXdiwwxai2dwJlRiGwE7rS.png",
//                name: "Spyglass Media Group",
//                originCountry: "US"
//            )
//        ],
//        productionCountries: [
//            Country(iso_3166_1: "US", name: "United States of America")
//        ],
//        releaseDate: "2022-01-12",
//        revenue: 137700000,
//        runtime: 114,
//        spokenLanguages: [
//            LanguageModel(englishName: "English", iso_3166_1: nil, iso_639_1: "en", iso_639_3: nil, name: "English")
//        ],
//        status: "Released",
//        tagline: "It's always someone you know.",
//        title: "Scream",
//        video: false,
//        voteAverage: 6.67,
//        voteCount: 3139,
//        
//    )
//}
