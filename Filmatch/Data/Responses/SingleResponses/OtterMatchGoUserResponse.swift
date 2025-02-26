//
//  FilmatchGoUserResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/1/25.
//

import Foundation

final class OtterMatchGoUserResponse: Sendable {
  let success: Bool
  let message: String?
  let user: OtterMatchUserResponse
  
  init(success: Bool, message: String?, user: OtterMatchUserResponse) {
    self.success = success
    self.message = message
    self.user = user
  }
}

extension OtterMatchGoUserResponse: Codable {
  enum CodingKeys: String, CodingKey {
    case success
    case message
    case user
  }
  
  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let success = try container.decode(Bool.self, forKey: .success)
    let message = try container.decodeIfPresent(String.self, forKey: .message)
    let user = try container.decode(OtterMatchUserResponse.self, forKey: .user)
    
    self.init(success: success,
              message: message,
              user: user)
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    try container.encode(success, forKey: .success)
    try container.encodeIfPresent(message, forKey: .message)
    try container.encode(user, forKey: .user)
  }
}
