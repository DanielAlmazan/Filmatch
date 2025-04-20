//
//  UpdateUsernameBody.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 19/4/25.
//

import Foundation

final class UpdateUsernameBody {
  let username: String

  init(username: String) {
    self.username = username
  }
}

extension UpdateUsernameBody: Encodable {
  private enum CodingKeys: String, CodingKey {
    case username = "username"
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(username, forKey: .username)
  }
}
