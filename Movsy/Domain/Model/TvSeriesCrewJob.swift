//
//  TvSeriesCrewJob.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class TvSeriesCrewJob: Identifiable, Sendable {
  let creditId: String
  let job: String
  let episodeCount: Int
  
  init(creditId: String, job: String, episodeCount: Int) {
    self.creditId = creditId
    self.job = job
    self.episodeCount = episodeCount
  }
}

extension TvSeriesCrewJob: Codable {
  enum CodingKeys: String, CodingKey {
    case creditId = "credit_id"
    case job
    case episodeCount = "episode_count"
  }
  
  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let creditId = try container.decode(String.self, forKey: .creditId)
    let job = try container.decode(String.self, forKey: .job)
    let episodeCount = try container.decode(Int.self, forKey: .episodeCount)
    
    self.init(creditId: creditId, job: job, episodeCount: episodeCount)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(creditId, forKey: .creditId)
    try container.encode(job, forKey: .job)
    try container.encode(episodeCount, forKey: .episodeCount)
  }
}

extension TvSeriesCrewJob: Equatable {
  static func == (lhs: TvSeriesCrewJob, rhs: TvSeriesCrewJob) -> Bool {
    lhs.creditId == rhs.creditId
  }
}
