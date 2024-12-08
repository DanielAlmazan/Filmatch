//
//  RuntimeError.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 2/12/24.
//

import Foundation

enum RuntimeError: Error {
  case canceled
  case error(Error)
  case message(String)
  
  var localizedDescription: String {
    switch self {
      case .canceled:
        return "The operation was canceled."
      case .error(let error):
        return error.localizedDescription
      case .message(let message):
        return message
    }
  }
}
