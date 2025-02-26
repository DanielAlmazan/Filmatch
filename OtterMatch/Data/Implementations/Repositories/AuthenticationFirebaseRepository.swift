//
//  AuthenticationFirebaseRepository.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

@preconcurrency import FirebaseAuth
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
  
  func getCurrentUser() async -> User? {
    return await self.dataSource.getCurrentUser()
  }
  
  func createNewUser(
    email: String,
    password: String
  ) async -> Result<User, Error> {
    await self.dataSource.createNewUser(email: email, password: password)
  }
  
  func logIn(
    email: String,
    password: String
  ) async -> Result<User, Error> {
    await self.dataSource.logIn(email: email, password: password)
  }
  
  func googleOAuth(tokens: GoogleSignInResultModel) async -> Result<User, Error> {
    await self.dataSource.googleOAuth(tokens: tokens)
  }
  
  func appleOAuth(tokens: SignInWithAppleResult) async -> Result<User, Error> {
    await self.dataSource.appleOAuth(tokens: tokens)
  }
  
  func logOut() async -> Result<Void, Error> {
    await self.dataSource.signOut()
  }
  
  func deleteAccount() async -> Result<Void, Error> {
    await self.dataSource.deleteUser()
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
