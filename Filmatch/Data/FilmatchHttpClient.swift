//
//  FilmatchHttpClient.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/1/25.
//

import Foundation
import FirebaseAuth

final class FilmatchHttpClient: FilmatchClient {
  private let urlBase: String
  private let session = URLSession(configuration: .default)

  init(urlBase: String) {
    self.urlBase = urlBase
  }
  
  func request(
    path: FilmatchGoPaths,
    method: HTTPMethods = .GET,
    queryParams: [String: String]? = nil,
    body: Data? = nil,
    acceptedStatusCodes: ClosedRange<Int> = 200...299
  ) async -> Result<Data, Error> {
    
    // 1) Verificar usuario y token Firebase
    guard let user = Auth.auth().currentUser else {
      return .failure(LoginError.notLoggedIn)
    }
    let token: String
    do {
      token = try await user.getIDTokenResult().token
    } catch {
      return .failure(error)
    }
    
    // 2) Construir URL con query params
    guard var components = URLComponents(string: "\(self.urlBase)\(path.stringValue)") else {
      return .failure(URLError(.badURL))
    }
    if let queryParams = queryParams, !queryParams.isEmpty {
      var items = [URLQueryItem]()
      for (key, value) in queryParams {
        items.append(URLQueryItem(name: key, value: value))
      }
      // mezclar con queryItems existentes, si hubiera
      components.queryItems = (components.queryItems ?? []) + items
    }
    
    guard let finalURL = components.url else {
      return .failure(URLError(.badURL))
    }
    
    // 3) Configurar URLRequest
    var request = URLRequest(url: finalURL)
    request.httpMethod = method.rawValue
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    if let body = body {
      request.httpBody = body
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
    
    // 4) Llamar URLSession
    do {
      let (data, response) = try await session.data(for: request)
      
      // 5) Verificar status code
      if let httpResponse = response as? HTTPURLResponse {
        if !acceptedStatusCodes.contains(httpResponse.statusCode) {
          // Podrías decodificar un error con JSONDecoder, si tu backend lo manda
          return .failure(URLError(.badServerResponse))
        }
      }
      return .success(data)
    } catch {
      return .failure(error)
    }
  }
  
  func request(
    path: FilmatchGoPaths,
    method: HTTPMethods
  ) async -> Result<Data, Error> {
    await self.request(path: path, method: method, queryParams: nil, body: nil)
  }
  
  // POST /user/auth
  /// Performs a POST request with a body the firebase token as a bearer
//  func auth() async -> Result<FilmatchUser, Error> {
//    let data = await self.request(path: .userAuth, httpMethod: .POST)
//    
//    switch data {
//    case .success(let success):
//      do {
//        let loginResponse = try JSONDecoder().decode(FilmatchGoUserResponse.self, from: success)
//        return .success(loginResponse.user)
//      } catch {
//        return .failure(error)
//      }
//    case .failure(let error):
//      return .failure(error)
//    }
//  }
//
//  func markMediaAsVisited() async {
//    // TODO: Implement
//  }
//
//  func getMovieVisitStatus() async {
//    // TODO: Implement
//  }
//
//  func getTvVisitStatus() async {
//    // TODO: Implement
//  }
//
//  func getTvVisitsByIds() async {
//    // TODO: Implement
//  }
//
//  func getMovieVisitsByIds() async {
//    // TODO: Implement
//  }
}
