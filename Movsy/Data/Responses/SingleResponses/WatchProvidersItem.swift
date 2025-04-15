//
//  WatchProvidersItem.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 16/1/25.
//

import Foundation

final class WatchProvidersItem: Identifiable, Sendable {
  let link: URL?
  let buy: [ProviderModel]?
  let rent: [ProviderModel]?
  let flatrate: [ProviderModel]?
  
  init(link: URL?, buy: [ProviderModel]?, rent: [ProviderModel]?, flatrate: [ProviderModel]?) {
    self.link = link
    self.buy = buy
    self.rent = rent
    self.flatrate = flatrate
  }
}

extension WatchProvidersItem: Codable {
  enum CodingKeys: String, CodingKey {
    case link
    case buy
    case rent
    case flatrate
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
   
    let link = try container.decodeIfPresent(URL.self, forKey: .link)
    let buy = try container.decodeIfPresent([ProviderModel].self, forKey: .buy)
    let rent = try container.decodeIfPresent([ProviderModel].self, forKey: .rent)
    let flatrate = try container.decodeIfPresent([ProviderModel].self, forKey: .flatrate)
    
    self.init(link: link, buy: buy, rent: rent, flatrate: flatrate)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encodeIfPresent(link, forKey: .link)
    try container.encodeIfPresent(buy, forKey: .buy)
    try container.encodeIfPresent(rent, forKey: .rent)
    try container.encodeIfPresent(flatrate, forKey: .flatrate)
  }
}
