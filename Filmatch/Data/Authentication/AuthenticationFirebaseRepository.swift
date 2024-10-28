//
//  AuthenticationFirebaseRepository.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

import Foundation
import SwiftUI

/// `AuthenticationFirebaseRepository` is a concrete implementation of `AuthenticationRepository` that uses Firebase for authentication services.
final class AuthenticationFirebaseRepository: AuthenticationRepository {
  /// The data source that interacts directly with Firebase APIs.
  let dataSource: AuthenticationFirebaseDataSource

  /// Initializes a new `AuthenticationFirebaseRepository` with the given data source.
  /// - Parameter dataSource: An instance of `AuthenticationFirebaseDataSource` used to perform Firebase authentication operations.
  init(dataSource: AuthenticationFirebaseDataSource) {
    self.dataSource = dataSource
  }

  // MARK: - AuthenticationRepository Methods

  func getCurrentUser() -> User? {
    self.dataSource.getCurrentUser()
  }

  func createNewUser(
    email: String, password: String,
    completionBlock: @escaping (Result<User, any Error>) -> Void
  ) {
    self.dataSource.createNewUser(email: email, password: password, completionBlock: completionBlock)
  }

  func logIn(
    email: String, password: String,
    completionBlock: @escaping (Result<User, any Error>) -> Void
  ) {
    self.dataSource.logIn(email: email, password: password, completionBlock: completionBlock)
  }

  func googleOAuth() async throws {
    try await self.dataSource.googleOAuth()
  }

  func logOut() throws {
    try self.dataSource.logOut()
  }

  func deleteAccount(
    completion: @escaping (Result<LocalizedStringResource, Error>) -> Void
  ) throws {
    try self.dataSource.deleteAccount(completion: completion)
  }
}

/// `FirebaseAuthenticationError` defines error types specific to Firebase authentication operations.
enum FirebaseAuthenticationError: Error {
  /// A runtime error with an associated message.
  case runtimeError(String)

  /// Indicates an invalid credential error with an associated localized message.
  case errorInvalidCredential(LocalizedStringResource)

  /// Indicates that recent login is required to perform an operation, with an associated localized message.
  case requiredRecentLogin(LocalizedStringResource)

  /// The error code associated with each error type.
  var code: Int {
    switch self {
    case .runtimeError:
      return 1
    case .errorInvalidCredential:
      return 17004
    case .requiredRecentLogin:
      return 17014
    }
  }
}
