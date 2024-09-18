//
//  WatchProvider.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/7/24.
//

import Foundation

final class MovieProvider: Codable, Sendable {
    let providerId: Int
    let providerName: String
    let logoPath: String
    let displayPriority: Int
    let displayPriorities: [String: Int]
    
    init(providerId: Int, providerName: String, logoPath: String, displayPriority: Int, displayPriorities: [String : Int]) {
        self.providerId = providerId
        self.providerName = providerName
        self.logoPath = logoPath
        self.displayPriorities = displayPriorities
        self.displayPriority = displayPriority
    }
}

extension MovieProvider {
    enum CodingKeys: String, CodingKey {
        case providerId = "provider_id"
        case providerName = "provider_name"
        case logoPath = "logo_path"
        case displayPriorities = "disply_priorities"
        case displayPriority = "disply_priority"
    }
}
