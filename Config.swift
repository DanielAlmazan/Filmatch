//
//  Config.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 16/8/24.
//

import Foundation

final class Config: Sendable {
    static let shared = Config()
    
    var accessTokenAuth: String {
        guard let path = Bundle.main.url(forResource: "Config", withExtension: "plist"),
              let config = NSDictionary(contentsOf: path),
              let apiKey = config["ACCESS_TOKEN_AUTH"] as? String else {
            fatalError("Access Token Auth not found in Config.plist")
        }
        return apiKey
    }
    
    var apiKey: String {
        guard let path = Bundle.main.url(forResource: "Config", withExtension: "plist"),
              let config = NSDictionary(contentsOf: path),
              let apiKey = config["API_KEY"] as? String else {
            fatalError("API Key not found in Config.plist")
        }
        return apiKey
    }
}
