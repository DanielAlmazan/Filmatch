//
//  AcceptFriendshipRequestBody.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/2/25.
//

import Foundation

final class AcceptFriendshipRequestBody: Sendable, Encodable {
  let friendUid: String
  
  init(friendUid: String) {
    self.friendUid = friendUid
  }
  
  private enum CodingKeys: String, CodingKey {
    case friendUid = "sender_uid"
  }
  
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(self.friendUid, forKey: .friendUid)
  }
}
