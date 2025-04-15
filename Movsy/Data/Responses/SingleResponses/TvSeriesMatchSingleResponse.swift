//
//  TvSeriesMatchSingleResponse.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 14/3/25.
//

import Foundation

final class TvSeriesMatchSingleResponse: Sendable {
  let isSuperMatch: Bool
  let tvSeries: DiscoverTvSeriesItemSingleResponse
  let status: InterestStatus
  
  init(isSuperMatch: Bool, tvSeries: DiscoverTvSeriesItemSingleResponse, status: InterestStatus) {
    self.isSuperMatch = isSuperMatch
    self.tvSeries = tvSeries
    self.status = status
  }
}

extension TvSeriesMatchSingleResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case isSuperMatch = "super_match"
    case tvSeries = "tv_show"
    case status
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let isSuperMatch = try container.decode(Bool.self, forKey: .isSuperMatch)
    let tvSeries = try container.decode(DiscoverTvSeriesItemSingleResponse.self, forKey: .tvSeries)
    let status = try container.decode(InterestStatus.self, forKey: .status)
    
    self.init(isSuperMatch: isSuperMatch, tvSeries: tvSeries, status: status)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(isSuperMatch, forKey: .isSuperMatch)
    try container.encode(tvSeries, forKey: .tvSeries)
    try container.encode(status, forKey: .status)
  }
}
