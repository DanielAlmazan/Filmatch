//
//  ProviderModel.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 11/1/25.
//

import Foundation

final class ProviderModel: Identifiable, Sendable {
  let providerId: Int
  let providerName: String?
  let logoPath: String?
  let displayPriority: Int?
  
  init(providerId: Int, providerName: String?, logoPath: String?, displayPriority: Int?) {
    self.providerId = providerId
    self.providerName = providerName
    self.logoPath = logoPath
    self.displayPriority = displayPriority
  }
}

extension ProviderModel: Codable {
  enum CodingKeys: String, CodingKey {
    case providerId = "provider_id"
    case providerName = "provider_name"
    case logoPath = "logo_path"
    case displayPriority = "display_priority"
  }
}
