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
  /// - Returns: An optional `User` object representing the current user, or `nil` if no user is logged in.
  func getCurrentUser() -> User?
  
  /// Creates a new user account with the provided email and password.
  /// - Parameters:
  ///   - email: The email address for the new user.
  ///   - password: The password for the new user.
  ///   - completionBlock: A closure that is called upon completion, containing a `Result` with either the created `User` or an `Error`.
  func createNewUser(email: String, password: String, completionBlock: @escaping (Result<User, Error>) -> Void)
  
  /// Logs in a user with the provided email and password.
  /// - Parameters:
  ///   - email: The email address of the user.
  ///   - password: The password of the user.
  ///   - completionBlock: A closure that is called upon completion, containing a `Result` with either the authenticated `User` or an `Error`.
  func logIn(email: String, password: String, completionBlock: @escaping (Result<User, Error>) -> Void)
  
  /// Initiates a Google OAuth authentication flow.
  /// - Throws: An error if the authentication process fails.
  func googleOAuth() async throws
  
  /// Logs out the currently authenticated user.
  /// - Throws: An error if the logout process fails.
  func logOut() throws
  
  /// Deletes the account of the currently authenticated user.
  /// - Parameter completion: A closure that is called upon completion, containing a `Result` with either a `LocalizedStringResource` message or an `Error`.
  /// - Throws: An error if the account deletion process fails.
  func deleteAccount(completion: @escaping (Result<LocalizedStringResource, Error>) -> Void) throws
}
