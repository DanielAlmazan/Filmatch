//
//  SignInGoogleHelper.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 4/12/24.
//

import Foundation
@preconcurrency import GoogleSignIn
import GoogleSignInSwift
import Firebase

final class SignInGoogleHelper {
  @MainActor
  func signIn() async throws -> GoogleSignInResultModel {
    guard let clientID = FirebaseApp.app()?.options.clientID else { throw URLError(.badServerResponse) }
    
    // Create Google Sign In configuration object.
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
    
    guard let topVC = Utilities.shared.topViewController() else {
      throw URLError(.cannotFindHost)
    }
    
    let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
    
    guard let idToken = gidSignInResult.user.idToken?.tokenString else {
      throw URLError(.badServerResponse)
    }
    
    let accessToken = gidSignInResult.user.accessToken.tokenString
    let name = gidSignInResult.user.profile?.name
    let email = gidSignInResult.user.profile?.email
    
    let result = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
    
    return result
  }
}
