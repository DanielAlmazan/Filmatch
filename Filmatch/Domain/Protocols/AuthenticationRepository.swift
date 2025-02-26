//
//  AuthenticationRepository.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

/// `AuthenticationRepository` defines a set of methods for handling user authentication and account management.
@MainActor protocol AuthenticationRepository {
  /// Retrieves the currently authenticated user, if any.
  /// - Returns: An optional `AuthenticationResult` representing the current user, or `nil` if no user is logged in.
  func getCurrentUser() async -> User?

  /// Creates a new user account with the provided email and password.
  /// - Parameters:
  ///   - email: The email address for the new user.
  ///   - password: The password for the new user.
  func createNewUser(
    email: String,
    password: String
  ) async -> Result<User, Error>

  /// Logs in a user with the provided email and password.
  /// - Parameters:
  ///   - email: The email address of the user.
  ///   - password: The password of the user.
  func logIn(
    email: String,
    password: String
  ) async -> Result<User, Error>

  /// Initiates a Google OAuth authentication flow.
  func googleOAuth(
    tokens: GoogleSignInResultModel
  ) async -> Result<User, Error>

  /// Initiates an AppleID OAuth authentication flow.
  func appleOAuth(
    tokens: SignInWithAppleResult
  ) async -> Result<User, Error>

  /// Logs out the currently authenticated user.
  /// - Returns: A `Result<Void, Error>` indicating success or failure.
  func logOut() async -> Result<Void, Error>

  /// Deletes the account of the currently authenticated user.
  func deleteAccount() async -> Result<Void, Error>
}
