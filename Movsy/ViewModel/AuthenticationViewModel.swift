//
//  AuthenticationViewModel.swift
//  Movsy
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
  var currentUser: MovsyUser?
  
  /// An optional error message if an authentication error occurs.
  var errorMessage: String?
  
  var isLoading = true

  func checkEmailVerification() async -> Bool {
    guard let user = Auth.auth().currentUser else { return false }
    do {
      try await user.reload()
      return user.isEmailVerified
    } catch {
      return false
    }
  }

  func refreshEmailVerificationStatus() async {
    let isVerified = await checkEmailVerification()
    self.currentUser?.isEmailVerified = isVerified
  }

  /// The repository responsible for handling authentication operations.
  private let authenticationRepository: AuthenticationRepository
  private let movsyRepository: MovsyGoRepository
  
  /// Initializes a new `AuthenticationViewModel`.
  /// - Parameter authenticationRepository: The repository used for authentication operations. Defaults to `AuthenticationFirebaseRepository`.
  /// - Parameter movsyRepository: Te repository used to ensure the validation of the user.
  init(
    authenticationRepository: AuthenticationRepository,
    movsyRepository: MovsyGoRepository,
  ) {
    self.authenticationRepository = authenticationRepository
    self.movsyRepository = movsyRepository

    // Listen for authentication state changes.
    let _ = Auth.auth().addStateDidChangeListener { auth, user in
      Task {
        self.isLoading = true

        if let firebaseUser = await self.authenticationRepository.getCurrentUser() {
          let movsyAuthResult = await self.movsyRepository.auth()
          switch movsyAuthResult {
          case .success(let movsyUser):
            self.currentUser = movsyUser.toMovsyUser(isEmailVerified: firebaseUser.isEmailVerified)
          case .failure(let failure):
            self.errorMessage = failure.localizedDescription
          }
        }
        self.isLoading = false
      }
    }
  }

  func sendEmailVerification() {
    Task {
      self.isLoading = true
      let result = await authenticationRepository.sendEmailVerification()
      switch result {
      case .success():
        print("Verification email sent")
      case .failure(let error):
        self.errorMessage = error.localizedDescription
      }
      self.isLoading = false
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
        let movsyResult = await self.movsyRepository.auth()
        switch movsyResult {
        case .success(let movsyUser):
          self.currentUser = movsyUser.toMovsyUser()
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
        let movsyResult = await self.movsyRepository.auth()
        switch movsyResult {
        case .success(let movsyUser):
          self.currentUser = movsyUser.toMovsyUser()
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
        let movsyResult = await self.movsyRepository.auth()
        switch movsyResult {
        case .success(let movsyUser):
          self.currentUser = movsyUser.toMovsyUser()
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
        let movsyResult = await self.movsyRepository.auth()
        switch movsyResult {
        case .success(let movsyUser):
          self.currentUser = movsyUser.toMovsyUser()
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
