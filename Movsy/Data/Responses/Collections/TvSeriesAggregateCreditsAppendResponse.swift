//
//  TvSeriesAggregateCreditsAppendResponse.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class TvSeriesAggregateCreditsAppendResponse: Identifiable, Sendable {
  let cast: [TvSeriesCastMember]
  let crew: [TvSeriesCrewMember]

  init(cast: [TvSeriesCastMember], crew: [TvSeriesCrewMember]) {
    self.cast = cast
    self.crew = crew
  }
}

extension TvSeriesAggregateCreditsAppendResponse: Codable {
  private enum CodingKeys: String, CodingKey {
    case cast = "cast"
    case crew = "crew"
  }

  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let cast = try container.decode([TvSeriesCastMember].self, forKey: .cast)
    let crew = try container.decode([TvSeriesCrewMember].self, forKey: .crew)

    self.init(cast: cast, crew: crew)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(cast, forKey: .cast)
    try container.encode(crew, forKey: .crew)
  }
}
