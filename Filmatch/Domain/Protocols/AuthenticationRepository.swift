//
//  AuthenticationRepository.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

import Foundation
import SwiftUI

/// `AuthenticationRepository` defines a set of methods for handling user authentication and account management.
protocol AuthenticationRepository {
  /// Retrieves the currently authenticated user, if any.
  /// - Returns: An optional `AuthenticationResult` representing the current user, or `nil` if no user is logged in.
  func getCurrentUser() -> AuthenticationResultModel?
  
  /// Creates a new user account with the provided email and password.
  /// - Parameters:
  ///   - email: The email address for the new user.
  ///   - password: The password for the new user.
  ///   - completion: A closure that is called upon completion, containing a `Result` with either the created `AuthenticationResult` or an `Error`.
  func createNewUser(
    email: String,
    password: String,
    completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void
  )
  
  /// Logs in a user with the provided email and password.
  /// - Parameters:
  ///   - email: The email address of the user.
  ///   - password: The password of the user.
  ///   - completion: A closure that is called upon completion, containing a `Result` with either the authenticated `AuthenticationResult` or an `Error`.
  func logIn(
    email: String,
    password: String,
    completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void
  )
  
  /// Initiates a Google OAuth authentication flow.
  /// - Parameter completion: Called upon completion with a `Result` containing the `AuthenticationResult` or an `Error`.
  func googleOAuth(tokens: GoogleSignInResultModel, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void)
  
  /// Initiates an AppleID OAuth authentication flow.
  /// - Parameter completion: Called upon completion with a `Result` containing the `AuthenticationResult` or an `Error`.
  func appleOAuth(tokens: SignInWithAppleResult, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void)
  
  /// Logs out the currently authenticated user.
  /// - Returns: A `Result<Void, Error>` indicating success or failure.
  func logOut(completion: @escaping (Result<Void, Error>) -> Void)
  
  /// Deletes the account of the currently authenticated user.
  /// - Parameter completion: A closure that is called upon completion, containing a `Result` with either `Void` or an `Error`.
  func deleteAccount(completion: @escaping (Result<Void, Error>) -> Void)
}
