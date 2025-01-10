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
  
  func getCurrentUser() -> AuthenticationResultModel? {
    return self.dataSource.getCurrentUser()
  }
  
  func createNewUser(
    email: String,
    password: String,
    completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void
  ) {
    self.dataSource.createNewUser(email: email, password: password, completion: completion)
  }
  
  func logIn(
    email: String,
    password: String,
    completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void
  ) {
    self.dataSource.logIn(email: email, password: password, completion: completion)
  }
  
  func googleOAuth(tokens: GoogleSignInResultModel, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    self.dataSource.googleOAuth(tokens: tokens, completion: completion)
  }
  
  func appleOAuth(tokens: SignInWithAppleResult, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    self.dataSource.appleOAuth(tokens: tokens, completion: completion)
  }
  
  func logOut(completion: @escaping (Result<Void, Error>) -> Void) {
    self.dataSource.signOut(completion: completion)
  }
  
  func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void) {
    self.dataSource.deleteUser(completion: completion)
  }
}

/// `FirebaseAuthenticationError` defines error types specific to Firebase authentication operations.
enum FirebaseAuthenticationError: Error {
  /// Indicates an invalid credential error with an associated localized message.
  case errorInvalidCredential(LocalizedStringResource)
  
  /// Indicates that recent login is required to perform an operation, with an associated localized message.
  case requiredRecentLogin(LocalizedStringResource)
  
  /// The error code associated with each error type.
  var code: Int {
    switch self {
      case .errorInvalidCredential:
        return 17004
      case .requiredRecentLogin:
        return 17014
    }
  }
}
