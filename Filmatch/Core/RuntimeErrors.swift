//
//  RuntimeErrors.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 2/1/25.
//

import Foundation

enum RuntimeErrors: Error {
  case notImplemented
}

enum LoginError: Error {
  case notLoggedIn
  case invalidCredentials
}
