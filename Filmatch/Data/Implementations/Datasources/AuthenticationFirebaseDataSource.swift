//
//  AuthenticationFirebaseDataSource.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import Foundation
import GoogleSignIn


/// `AuthenticationFirebaseDataSource` is a class responsible for handling authentication operations using Firebase and Google Sign-In.
/// It provides methods to create new users, log in existing users, perform Google OAuth authentication, log out users, and delete user accounts.
final class AuthenticationFirebaseDataSource: Sendable {
  
  func getCurrentUser() async -> User? {
    Auth.auth().currentUser
  }
  
  func signOut() async -> Result<Void, Error> {
    do {
      try Auth.auth().signOut()
      return .success(())
    } catch {
      return .failure(error)
    }
  }
  
  func deleteUser() async -> Result<Void, Error> {
    guard let user = Auth.auth().currentUser else {
      return .failure(URLError(.badServerResponse))
    }
    do {
      try await user.delete()
      return .success(())
    } catch {
      return .failure(error)
    }
  }
}

// MARK: - SIGN IN EMAIL
extension AuthenticationFirebaseDataSource {
  func createNewUser(email: String, password: String) async -> Result<User, Error> {
    do {
      let registerResult = try await Auth.auth().createUser(withEmail: email, password: password)
      return .success(registerResult.user)
    } catch {
      return .failure(error)
    }
  }

  func logIn(email: String, password: String) async -> Result<User, Error> {
    do {
      let loginResult = try await Auth.auth().signIn(withEmail: email, password: password)
      return .success(loginResult.user)
    } catch {
      return .failure(error)
    }
  }

  func resetPassword(email: String) async -> Result<Void, Error> {
    guard let _ = Auth.auth().currentUser else {
      return .failure(URLError(.badServerResponse))
    }

    do {
      try await Auth.auth().sendPasswordReset(withEmail: email)
      return .success(())
    } catch {
      return .failure(error)
    }
  }

  func updatePassword(password: String) async -> Result<Void, Error> {
    guard let user = Auth.auth().currentUser else {
      return .failure(URLError(.badServerResponse))
    }
    
    do {
      try await user.updatePassword(to: password)
      return .success(())
    } catch {
      return .failure(error)
    }
  }

  func updateEmail(email: String) async -> Result<Void, Error> {
    guard let user = Auth.auth().currentUser else {
      return .failure(URLError(.badServerResponse))
    }

    do {
      try await user.sendEmailVerification(beforeUpdatingEmail: email)
      return .success(())
    } catch {
      return .failure(error)
    }
  }
}

// MARK: - SIGN IN OAUTH

extension AuthenticationFirebaseDataSource {
  func googleOAuth(tokens: GoogleSignInResultModel) async -> Result<User, Error> {
    let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
    return await signIn(credential: credential)
  }
  
  func appleOAuth(tokens: SignInWithAppleResult) async -> Result<User, Error> {
    let credential = OAuthProvider.credential(providerID: .apple, idToken: tokens.token, rawNonce: tokens.nonce)
    return await signIn(credential: credential)
  }
  
  func signIn(credential: AuthCredential) async -> Result<User, Error> {
    do {
      let signInResult = try await Auth.auth().signIn(with: credential)
      return .success(signInResult.user)
    } catch {
      return .failure(error)
    }
  }
}
// MARK: - SIGN IN ANONYMOUS

extension AuthenticationFirebaseDataSource {
  func signInAnonymously() async -> Result<User, Error> {
    do {
      let anonymousResult = try await Auth.auth().signInAnonymously()
      return .success(anonymousResult.user)
    } catch {
      return .failure(error)
    }
  }
  
  func linkEmail(email: String, password: String) async -> Result<Void, Error> {
    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
    return await linkCredential(credential: credential)
  }
  
  func linkGoogle(tokens: GoogleSignInResultModel) async -> Result<Void, Error> {
    let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
    return await linkCredential(credential: credential)
  }
  
  func linkApple(tokens: SignInWithAppleResult) async -> Result<Void, Error> {
    let credential = OAuthProvider.credential(providerID: .apple, idToken: tokens.token, rawNonce: tokens.nonce)
    return await linkCredential(credential: credential)
  }
  
  private func linkCredential(
    credential: AuthCredential) async -> Result<Void, Error> {
      guard let user = Auth.auth().currentUser else {
        return .failure(URLError(.badURL))
      }
      
      do {
        try await user.link(with: credential)
        return .success(())
      } catch {
        return .failure(error)
      }
    }
}
