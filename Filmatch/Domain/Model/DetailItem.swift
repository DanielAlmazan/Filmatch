//
//  DetailItem.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 8/1/25.
//

import Foundation

protocol DetailItem {
  var id: Int { get }
  var adult: Bool { get }
  var backdropPath: String? { get }
  var genres: [Genre] { get }
  var homepage: String? { get }
  var originCountry: [String] { get }
  var originalLanguage: String? { get }
  var overview: String { get }
  var popularity: Double { get }
  var posterPath: String? { get }
  var productionCompanies: [ProductionCompany] { get }
  var productionCountries: [Country] { get }
  var spokenLanguages: [LanguageModel] { get }
  var status: String? { get }
  var tagline: String? { get }
  var voteAverage: Double { get }
  var voteCount: Int { get }
}
