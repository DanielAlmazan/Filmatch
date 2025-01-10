//
//  AuthenticationFirebaseDataSource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleSignIn


/// `AuthenticationFirebaseDataSource` is a class responsible for handling authentication operations using Firebase and Google Sign-In.
/// It provides methods to create new users, log in existing users, perform Google OAuth authentication, log out users, and delete user accounts.
final class AuthenticationFirebaseDataSource: Sendable {
  static let shared = AuthenticationFirebaseDataSource()
  private init() {}
  
  func getCurrentUser() -> AuthenticationResultModel? {
    guard let user = Auth.auth().currentUser else {
      return nil
    }
    return .init(user: user)
  }
  
  func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
    do {
      try Auth.auth().signOut()
      completion(.success(()))
    } catch {
      completion(.failure(error))
    }
  }
  
  func deleteUser(completion: @escaping (Result<Void, Error>) -> Void) {
    guard let user = Auth.auth().currentUser else {
      completion(.failure(URLError(.badServerResponse)))
      return
    }
    user.delete { error in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(()))
      }
    }
  }
}

// MARK: - SIGN IN EMAIL
extension AuthenticationFirebaseDataSource {
  func createNewUser(email: String, password: String, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
      if let error = error {
        completion(.failure(error))
      } else if let user = authResult?.user {
        completion(.success(AuthenticationResultModel(user: user)))
      } else {
        completion(.failure(URLError(.badServerResponse)))
      }
    }
  }
  
  func logIn(email: String, password: String, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
      if let error = error {
        completion(.failure(error))
      } else if let user = authResult?.user {
        completion(.success(AuthenticationResultModel(user: user)))
      } else {
        completion(.failure(URLError(.badServerResponse)))
      }
    }
  }
  
  func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
    Auth.auth().sendPasswordReset(withEmail: email) { error in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(()))
      }
    }
  }

  func updatePassword(password: String, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let user = Auth.auth().currentUser else {
      completion(.failure(URLError(.badServerResponse)))
      return
    }
    
    user.updatePassword(to: password) { error in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(()))
      }
    }
  }

  func updateEmail(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
    guard let user = Auth.auth().currentUser else {
      completion(.failure(URLError(.badServerResponse)))
      return
    }
    
    user.sendEmailVerification(beforeUpdatingEmail: email) { error in
      if let error = error {
        completion(.failure(error))
      } else {
        completion(.success(()))
      }
    }
  }
}

// MARK: - SIGN IN OAUTH

extension AuthenticationFirebaseDataSource {
  func googleOAuth(tokens: GoogleSignInResultModel, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
    signIn(credential: credential, completion: completion)
  }
  
  func appleOAuth(tokens: SignInWithAppleResult, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    let credential = OAuthProvider.credential(providerID: .apple, idToken: tokens.token, rawNonce: tokens.nonce)
    signIn(credential: credential, completion: completion)
  }
  
  func signIn(credential: AuthCredential, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    Auth.auth().signIn(with: credential) { authResult, error in
      if let error = error {
        completion(.failure(error))
      } else if let user = authResult?.user {
        completion(.success(AuthenticationResultModel(user: user)))
      } else {
        completion(.failure(URLError(.badServerResponse)))
      }
    }
  }
}

// MARK: - SIGN IN ANONYMOUS

extension AuthenticationFirebaseDataSource {
  func signInAnonymously(completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    Auth.auth().signInAnonymously { authResult, error in
      if let error = error {
        completion(.failure(error))
      } else if let user = authResult?.user {
        completion(.success(AuthenticationResultModel(user: user)))
      } else {
        completion(.failure(URLError(.badServerResponse)))
      }
    }
  }
  
  func linkEmail(email: String, password: String, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
    linkCredential(credential: credential, completion: completion)
  }
  
  func linkGoogle(tokens: GoogleSignInResultModel, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
    linkCredential(credential: credential, completion: completion)
  }
  
  func linkApple(tokens: SignInWithAppleResult, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    let credential = OAuthProvider.credential(providerID: .apple, idToken: tokens.token, rawNonce: tokens.nonce)
    linkCredential(credential: credential, completion: completion)
  }
  
  private func linkCredential(credential: AuthCredential, completion: @escaping (Result<AuthenticationResultModel, Error>) -> Void) {
    guard let user = Auth.auth().currentUser else {
      completion(.failure(URLError(.badURL)))
      return
    }
    
    user.link(with: credential) { authResult, error in
      if let error = error {
        completion(.failure(error))
      } else if let linkedUser = authResult?.user {
        completion(.success(AuthenticationResultModel(user: linkedUser)))
      } else {
        completion(.failure(URLError(.badServerResponse)))
      }
    }
  }
}
