//
//  AuthenticationViewModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

import FirebaseAuth
import Foundation
import SwiftUI

/// `AuthenticationViewModel` manages user authentication state and actions.
/// It provides methods for user registration, login, logout, and account deletion.
@Observable
@MainActor
class AuthenticationViewModel {
  /// The currently authenticated user, if any.
  var currentUser: AuthenticationResultModel?
  
  /// An optional error message if an authentication error occurs.
  var errorMessage: String?
  
  /// The repository responsible for handling authentication operations.
  private let authenticationRepository: AuthenticationRepository
  
  /// Initializes a new `AuthenticationViewModel`.
  /// - Parameter authenticationRepository: The repository used for authentication operations. Defaults to `AuthenticationFirebaseRepository`.
  init(
    authenticationRepository: AuthenticationRepository =
      AuthenticationFirebaseRepository(
        dataSource: AuthenticationFirebaseDataSource.shared)
  ) {
    self.authenticationRepository = authenticationRepository

    // Listen for authentication state changes.
    let _ = Auth.auth().addStateDidChangeListener { auth, user in
      self.currentUser = self.authenticationRepository.getCurrentUser()
    }
  }

  /// Creates a new user account with the provided email and password.
  /// - Parameters:
  ///   - email: The email address of the new user.
  ///   - password: The password for the new user.
  func createNewUser(email: String, password: String) {
    authenticationRepository.createNewUser(email: email, password: password) {
      [weak self] result in
      switch result {
        case .success(let user):
          print("User created successfully: \(user.email ?? "No email")")
          self?.currentUser = user
        case .failure(let error):
          print("Error creating user: \(error.localizedDescription)")
          self?.errorMessage = error.localizedDescription
      }
    }
  }
  
  func appleOAuth() async throws {
    let helper = SignInAppleHelper()
    let tokens = try await helper.startSignInWithAppleFlow()
    authenticationRepository.appleOAuth(tokens: tokens) { result in
      switch result {
        case .success(let user):
          self.currentUser = user
        case .failure(let error):
          self.errorMessage = error.localizedDescription
      }
    }
  }
  
  /// Logs in a user with the provided email and password.
  /// - Parameters:
  ///   - email: The email address of the user.
  ///   - password: The password of the user.
  func logIn(email: String, password: String) {
    authenticationRepository.logIn(email: email, password: password) { result in
      switch result {
      case .success(let user):
        print("User logged in successfully: \(user.email ?? "No email")")
        self.currentUser = user
      case .failure(let error):
        print("Error logging user in: \(error.localizedDescription)")
        self.errorMessage = error.localizedDescription
      }
    }
  }

  /// Initiates Google OAuth authentication flow.
  func googleOAuth() async throws {
    let helper = SignInGoogleHelper()
    let tokens = try await helper.signIn()
    authenticationRepository.googleOAuth(tokens: tokens) { result in
      switch result {
        case .success(let user):
          self.currentUser = user
        case .failure(let error):
          self.errorMessage = error.localizedDescription
      }
    }
  }
  
  /// Logs out the currently authenticated user.
  func logOut() {
    authenticationRepository.logOut { result in
      switch result {
        case .success():
          self.currentUser = nil
        case .failure(let error):
          print("Error logging out: \(error.localizedDescription)")
      }
    }
  }

  /// Deletes the account of the currently authenticated user.
  /// - Parameter completion: A closure called upon completion with a success message or an error.
  func deleteAccount(
    completion: @escaping (Result<Void, Error>) -> Void
  ) {
    authenticationRepository.deleteAccount(completion: completion)
  }
}
