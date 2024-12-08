//
//  SignInWithAppleResult.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 4/12/24.
//

import Foundation

struct SignInWithAppleResult {
  let token: String
  let nonce: String
  let name: String?
  let email: String?
}
