//
//  GoogleSignInResultModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 4/12/24.
//

import Foundation

struct GoogleSignInResultModel {
  let idToken: String
  let accessToken: String
  let name: String?
  let email: String?
}
