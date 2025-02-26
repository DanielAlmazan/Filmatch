//
//  Config.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 16/8/24.
//

import Foundation

enum Config {
  enum Error: Swift.Error {
    case missingKey, invalidValue
  }
  
  static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
    guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
      throw Error.missingKey
    }
    
    switch object {
    case let value as T:
      return value
    case let string as String:
      guard let value = T(string) else { fallthrough }
      return value
    default:
      throw Error.invalidValue
    }
  }
}

enum API {
  static var otterMatchBaseURL: String? {
    return try? "https://" + Config.value(for: "OTTERMATCH_BASE_URL")
  }
  
  static var tmdbBaseURL: String? {
    return try? "https://" + Config.value(for: "TMDB_URL_BASE")
  }
  
  static var tmdbMediaBaseURL: String? {
    return try?"https://" + Config.value(for: "TMDB_MEDIA_BASE")
  }
  
  static var accessTokenAuth: String? {
    return try? Config.value(for: "ACCESS_TOKEN_AUTH")
  }
  
  static var apiKey: String? {
    return try? Config.value(for: "API_KEY")
  }
}
