//
//  SocialLoginModel.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 2/12/24.
//

import Foundation

public struct SocialLoginModel: Codable, Sendable {
  public var accessToken: String
  public var refreshToken: String?
  public var expiresIn: Int?
  public var provider: String?
  
  public var expirationDate: Date? {
    guard let expiresIn = expiresIn else { return nil }
    return Date().addingTimeInterval(TimeInterval(expiresIn))
  }
  
  public var isTokenExpired: Bool {
    guard let expirationDate = expirationDate else { return false }
    return Date() >= expirationDate
  }
  
  public init(accessToken: String, refreshToken: String? = nil, expiresIn: Int? = nil, provider: String? = nil) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
    self.expiresIn = expiresIn
    self.provider = provider
  }
  
  public static func from(json: [String: Any]) throws -> SocialLoginModel {
    let data = try JSONSerialization.data(withJSONObject: json)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(SocialLoginModel.self, from: data)
  }
  
  public func toJSON() throws -> [String: Any] {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    let data = try encoder.encode(self)
    guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
      throw NSError(domain: "SocialLoginModel", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert to JSON"])
    }
    return json
  }
}
