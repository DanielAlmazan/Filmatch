//
//  AuthenticationFirebaseDataSource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleSignIn
import SwiftUI

/// `AuthenticationFirebaseDataSource` is a class responsible for handling authentication operations using Firebase and Google Sign-In.
/// It provides methods to create new users, log in existing users, perform Google OAuth authentication, log out users, and delete user accounts.
final class AuthenticationFirebaseDataSource {
  /// Retrieves the currently authenticated user, if any.
  /// - Returns: An optional `User` object containing the email and providers of the current user, or `nil` if no user is logged in.
  func getCurrentUser() -> User? {
    guard let email = Auth.auth().currentUser?.email else { return nil }
    return .init(email: email, providers: [])
  }

  /// Creates a new user account with the provided email and password.
  /// - Parameters:
  ///   - email: The email address for the new user.
  ///   - password: The password for the new user.
  ///   - completionBlock: A closure that is called upon completion, containing a `Result` with either the created `User` or an `Error`.
  func createNewUser(
    email: String, password: String,
    completionBlock: @escaping (Result<User, Error>) -> Void
  ) {
    Auth.auth().createUser(withEmail: email, password: password) {
      result, error in
      if let error = error {
        print("DataSource | Error creating user: \(error)")
        completionBlock(.failure(error))
        return
      }

      let email = result?.user.email ?? "No email"
      print("User created with email: \(email)")
      completionBlock(.success(.init(email: email, providers: [])))
    }
  }

  /// Logs in a user with the provided email and password.
  /// - Parameters:
  ///   - email: The email address of the user.
  ///   - password: The password of the user.
  ///   - completionBlock: A closure that is called upon completion, containing a `Result` with either the authenticated `User` or an `Error`.
  func logIn(
    email: String,
    password: String,
    completionBlock: @escaping (Result<User, Error>) -> Void
  ) {
    Auth.auth().signIn(withEmail: email, password: password) {
      result, error in
      if let error = error {
        print("DataSource | Error logging in user: \(error)")
        completionBlock(.failure(error))
        return
      }

      let email = result?.user.email ?? "No email"
      print("User logged in with email: \(email)")
      completionBlock(.success(.init(email: email, providers: [])))
    }
  }

  /// Initiates a Google OAuth authentication flow.
  /// - Throws: An error if the authentication process fails.
  func googleOAuth() async throws {
    // Ensure the Firebase client ID is available.
    guard let clientID = FirebaseApp.app()?.options.clientID else {
      fatalError("Missing Firebase clientID")
    }

    // Configure Google Sign-In with the client ID.
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config

    // Start the sign-in flow.
    let result = try await GIDSignIn.sharedInstance.signIn(
      withPresenting: try await getRootViewController()
    )

    let user = result.user
    
    // Check if the signed-in user matches the current Firebase user.
    if let currentUser = Auth.auth().currentUser, currentUser != user {
      throw FirebaseAuthenticationError.runtimeError(
        "You tried to sign in with a different user")
    }
    
    // Retrieve the ID token from the Google user.
    guard let idToken = user.idToken?.tokenString else {
      throw FirebaseAuthenticationError.runtimeError(
        "Unexpected error occurred, please retry")
    }

    // Create a Firebase credential with the Google ID token and access token.
    let credential = GoogleAuthProvider.credential(
      withIDToken: idToken, accessToken: user.accessToken.tokenString)
    
    // Sign in to Firebase with the credential.
    try await Auth.auth().signIn(with: credential)
  }

  /// Retrieves the root view controller for presenting authentication views.
  /// - Returns: The root `UIViewController`.
  /// - Throws: An error if the root view controller cannot be found.
  func getRootViewController() async throws -> UIViewController {
    let scene =
      await UIApplication.shared.connectedScenes.first as? UIWindowScene
    guard
      let rootViewController = await scene?.windows.first?.rootViewController
    else {
      throw FirebaseAuthenticationError.runtimeError(
        "Missing root view controller")
    }

    return rootViewController
  }

  /// Logs out the currently authenticated user from Firebase and Google Sign-In.
  /// - Throws: An error if the logout process fails.
  func logOut() throws {
    GIDSignIn.sharedInstance.signOut()
    try Auth.auth().signOut()
  }

  /// Deletes the account of the currently authenticated user.
  /// - Parameter completion: A closure that is called upon completion, containing a `Result` with either a success message or an `Error`.
  /// - Throws: An error if the account deletion process fails.
  func deleteAccount(
    completion: @escaping (Result<LocalizedStringResource, Error>) -> Void
  ) throws {
    guard let user = Auth.auth().currentUser else {
      completion(
        .failure(FirebaseAuthenticationError.runtimeError("Missing user")))
      return
    }

    user.delete { error in
      if let error {
        completion(.failure(error))
        print("\n\n\n\(error)")
      } else {
        completion(.success(("Account deleted successfully")))
        print("Account deleted successfully")
      }
    }
  }
}
