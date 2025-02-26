//
//  SendFriendshipBody.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/2/25.
//

import Foundation

final class SendFriendshipBody: Sendable, Encodable {
  let userUid: String
  
  init(userUid: String) {
    self.userUid = userUid
  }
  
  private enum CodingKeys: String, CodingKey {
    case userUid = "user_uid"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(self.userUid, forKey: .userUid)
  }
}
