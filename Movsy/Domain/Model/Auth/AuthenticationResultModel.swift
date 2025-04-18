//
//  AuthenticationResult.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 4/12/24.
//

import Foundation
import FirebaseAuth

struct AuthenticationResultModel {
  let uid: String
  let email: String?
  let photoUrl: String?
  let isAnonymous: Bool
  
  init(user: User) {
    self.uid = user.uid
    self.email = user.email
    self.photoUrl = user.photoURL?.absoluteString
    self.isAnonymous = user.isAnonymous
  }
}
