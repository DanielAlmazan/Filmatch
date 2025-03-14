//
//  TvSeriesMatchSingleResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 14/3/25.
//

import Foundation

final class TvSeriesMatchSingleResponse {
  let isSuperMatch: Bool
  let tvSeries: [DiscoverTvSeriesItemSingleResponse]
  
  init(isSuperMatch: Bool, tvSeries: [DiscoverTvSeriesItemSingleResponse]) {
    self.isSuperMatch = isSuperMatch
    self.tvSeries = tvSeries
  }
}

extension TvSeriesMatchSingleResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case isSuperMatch = "super_match"
    case tvSeries = "tv_show"
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let isSuperMatch = try container.decode(Bool.self, forKey: .isSuperMatch)
    let tvSeries = try container.decode([DiscoverTvSeriesItemSingleResponse].self, forKey: .tvSeries)
    
    self.init(isSuperMatch: isSuperMatch, tvSeries: tvSeries)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(isSuperMatch, forKey: .isSuperMatch)
    try container.encode(tvSeries, forKey: .tvSeries)
  }
}
