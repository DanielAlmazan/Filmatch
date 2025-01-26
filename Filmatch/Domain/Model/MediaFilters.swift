//
//  MediaFilters.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 16/12/24.
//

import CryptoKit
import Foundation

struct MediaFilters {
  enum MinRating: Double {
    case gte50 = 5
    case gte75 = 7.5
  }
  enum MaxDuration: Int {
    case lte95 = 95
    case lte120 = 120
  }

  let mediaType: MediaType
  var genres: [Genre] = []
  var providers: [FiltersStreamingProviderSingleResponse] = []
  var maxRuntime: MaxDuration?
  var minRating: MinRating?
  var from: Int
  var to: Int

  let minYear: Int = 1940
  let maxYear: Int

  var fromRange: ClosedRange<Int> {
    minYear...to
  }
  var toRange: ClosedRange<Int> {
    from...maxYear
  }

  init(for mediaType: MediaType) {
    self.from = minYear
    if let tenYearsAgo: Date = Calendar.current.date(
      byAdding: .year, value: -20, to: Date())
    {
      let year = Calendar.current.component(.year, from: tenYearsAgo)
      if year > minYear { self.from = year }
    }

    self.maxYear = Calendar.current.component(.year, from: Date())
    self.to = Calendar.current.component(.year, from: Date())

    self.mediaType = mediaType
  }

  func getQueryParams(page: Int?) -> [URLQueryItem] {
    var params: [URLQueryItem] = []

    params.append(.init(name: QueryParam.page.rawValue, value: "\(page ?? 1)"))

    if !genres.isEmpty {
      params.append(genres.toUrlQueryItem(separator: .or))
    }
    if !providers.isEmpty {
      params.append(providers.toUrlQueryItem(separator: .or))
    }
    if let minRating {
      params.append(
        .init(
          name: QueryParam.voteAverageGte.rawValue,
          value: "\(minRating.rawValue)"
        )
      )
    }
    if let maxRuntime {
      params.append(
        .init(
          name: QueryParam.withRuntimeLte.rawValue,
          value: "\(maxRuntime.rawValue)"
        )
      )
    }

    let fromString = "\(from)-01-01"
    let toString = "\(to)-12-31"

    let fromYearQueryName: String =
      switch mediaType {
      case .movie: QueryParam.primaryReleaseDateGte.rawValue
      case .tvSeries: QueryParam.firstAirDateYearGte.rawValue
      }
    params.append(.init(name: fromYearQueryName, value: "\(fromString)"))

    let toYearQueryName: String =
      switch mediaType {
      case .movie: QueryParam.primaryReleaseDateLte.rawValue
      case .tvSeries: QueryParam.firstAirDateYearLte.rawValue
      }
    params.append(.init(name: toYearQueryName, value: "\(toString)"))

    return params
  }

  func filtersHash() -> String {
    let mediaType = self.mediaType.rawValue
    let genres = self.genres.sorted(by: { $0.id < $1.id }).map { "\($0.id)" }
      .joined(separator: QueryParamSeparator.or.rawValue)
    let providers = self.providers.sorted(by: { $0.providerId < $1.providerId })
      .map { "\($0.providerId)" }.joined(
        separator: QueryParamSeparator.or.rawValue)
    let score = "\(self.minRating?.rawValue.description ?? "null")"
    let from = "\(self.from)"
    let to = "\(self.to)"
    let sortBy = "popularity.desc"

    let joined = [
      mediaType,
      genres,
      providers,
      score,
      from,
      to,
      sortBy,
    ].joined(separator: "-")

    print("Joined: \(joined)")

    return Insecure.MD5.hash(data: joined.data(using: .utf8)!).map {
      String(format: "%02hhx", $0)
    }.joined()
  }
}

extension MediaFilters: Equatable {
  static func == (lhs: MediaFilters, rhs: MediaFilters) -> Bool {
    lhs.mediaType == rhs.mediaType
      && lhs.genres == rhs.genres
      && lhs.providers == rhs.providers
      && lhs.maxRuntime == rhs.maxRuntime
      && lhs.minRating == rhs.minRating
      && lhs.from == rhs.from
      && lhs.to == rhs.to
  }
}
