//
//  AuthenticationViewModel.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

@preconcurrency import FirebaseAuth
import Foundation
import SwiftUI

/// `AuthenticationViewModel` manages user authentication state and actions.
/// It provides methods for user registration, login, logout, and account deletion.
@Observable
@MainActor
class AuthenticationViewModel {
  /// The currently authenticated user, if any.
  var currentUser: OtterMatchUser?
  
  /// An optional error message if an authentication error occurs.
  var errorMessage: String?
  
  var isLoading = true
  
  /// The repository responsible for handling authentication operations.
  private let authenticationRepository: AuthenticationRepository
  private let otterMatchRepository: OtterMatchGoRepository
  
  /// Initializes a new `AuthenticationViewModel`.
  /// - Parameter authenticationRepository: The repository used for authentication operations. Defaults to `AuthenticationFirebaseRepository`.
  /// - Parameter otterMatchRepository: Te repository used to ensure the validation of the user.
  init(
    authenticationRepository: AuthenticationRepository =
      AuthenticationFirebaseRepository(
        dataSource: AuthenticationFirebaseDataSource()),
    otterMatchRepository: OtterMatchGoRepository
  ) {
    self.authenticationRepository = authenticationRepository
    self.otterMatchRepository = otterMatchRepository

    // Listen for authentication state changes.
    let _ = Auth.auth().addStateDidChangeListener { auth, user in
      Task {
        self.isLoading = true
        let userResult = await self.authenticationRepository.getCurrentUser()
        if let _ = userResult {
          let otterMatchAuthResult = await self.otterMatchRepository.auth()
          switch otterMatchAuthResult {
          case .success(let otterMatchUser):
            self.currentUser = otterMatchUser.toOtterMatchUser()
          case .failure(let failure):
            self.errorMessage = failure.localizedDescription
          }
        }
        self.isLoading = false
      }
    }
  }

  /// Creates a new user account with the provided email and password.
  /// - Parameters:
  ///   - email: The email address of the new user.
  ///   - password: The password for the new user.
  func createNewUser(email: String, password: String) {
    Task {
      self.isLoading = true
      let result = await authenticationRepository.createNewUser(email: email, password: password)
      
      switch result {
      case .success(_):
        let otterMatchResult = await self.otterMatchRepository.auth()
        switch otterMatchResult {
        case .success(let otterMatchUser):
          self.currentUser = otterMatchUser.toOtterMatchUser()
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        }
      case .failure(let error):
        self.errorMessage = error.localizedDescription
      }
      self.isLoading = false
    }
  }
  
  func appleOAuth() throws {
    Task {
      self.isLoading = true
      let helper = SignInAppleHelper()
      let tokens = try await helper.startSignInWithAppleFlow()
      let result = await authenticationRepository.appleOAuth(tokens: tokens)
      switch result {
      case .success(_):
        let otterMatchResult = await self.otterMatchRepository.auth()
        switch otterMatchResult {
        case .success(let otterMatchUser):
          self.currentUser = otterMatchUser.toOtterMatchUser()
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        }
      case .failure(let error):
        self.errorMessage = error.localizedDescription
      }
      self.isLoading = false
    }
  }
  
  /// Logs in a user with the provided email and password.
  /// - Parameters:
  ///   - email: The email address of the user.
  ///   - password: The password of the user.
  func logIn(email: String, password: String) {
    Task {
      self.isLoading = true
      let result = await authenticationRepository.logIn(email: email, password: password)
      switch result {
      case .success(_):
        let otterMatchResult = await self.otterMatchRepository.auth()
        switch otterMatchResult {
        case .success(let otterMatchUser):
          self.currentUser = otterMatchUser.toOtterMatchUser()
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        }
      case .failure(let error):
        self.errorMessage = error.localizedDescription
      }
      self.isLoading = false
    }
  }

  /// Initiates Google OAuth authentication flow.
  func googleOAuth() throws {
    Task {
      self.isLoading = true
      let helper = SignInGoogleHelper()
      let tokens = try await helper.signIn()
      let result = await authenticationRepository.googleOAuth(tokens: tokens)
      switch result {
      case .success(_):
        let otterMatchResult = await self.otterMatchRepository.auth()
        switch otterMatchResult {
        case .success(let otterMatchUser):
          self.currentUser = otterMatchUser.toOtterMatchUser()
        case .failure(let error):
          self.errorMessage = error.localizedDescription
        }
      case .failure(let error):
        self.errorMessage = error.localizedDescription
      }
      self.isLoading = false
    }
  }
  
  /// Logs out the currently authenticated user.
  func logOut() {
    Task {
      self.isLoading = true
      let result = await authenticationRepository.logOut()
      switch result {
      case .success():
        self.currentUser = nil
      case .failure(let error):
        print("Error logging out: \(error.localizedDescription)")
        self.errorMessage = error.localizedDescription
      }
      self.isLoading = false
    }
  }

  /// Deletes the account of the currently authenticated user.
  func deleteAccount() async -> Result<Void, Error> {
    await authenticationRepository.deleteAccount()
  }
}
