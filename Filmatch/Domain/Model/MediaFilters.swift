//
//  MediaFilters.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 16/12/24.
//

import Foundation

struct MediaFilters {
  var genres: [Genre] = []
  var providers: [StreamingProviderSingleResponse] = []
  var minRating: Double?

  var minYear: Int?
  var maxYear: Int?

  func getQueryParams(page: Int?) -> [URLQueryItem] {
    var params: [URLQueryItem] = []

    params.append(.init(name: QueryParam.page.rawValue, value: "\(page ?? 1)"))

    if !genres.isEmpty {
      params.append(genres.toUrlQueryItem(separator: .or))
    }
    if !providers.isEmpty {
      params.append(providers.toUrlQueryItem(separator: .or))
    }
    if let minRating = minRating {
      params += [.init(name: QueryParam.year.rawValue, value: "\(minRating)")]
    }

    return params
  }
}

extension MediaFilters: Equatable {
  static func == (lhs: MediaFilters, rhs: MediaFilters) -> Bool {
    lhs.genres == rhs.genres
    && lhs.providers == rhs.providers
    && lhs.minRating == rhs.minRating
    && lhs.minYear == rhs.minYear
    && lhs.maxYear == rhs.maxYear
  }
}
