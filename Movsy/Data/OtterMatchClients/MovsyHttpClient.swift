//
//  MovsyHttpClient.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 26/1/25.
//

import FirebaseAuth
import Foundation

final class MovsyHttpClient: MovsyClient {
  private let urlBase: String?
  private let session = URLSession(configuration: .default)

  init(urlBase: String? = API.movsyBaseURL) {
    self.urlBase = urlBase
  }

  func request(
    path: MovsyGoPaths,
    method: HTTPMethods = .GET,
    queryParams: [MovsyGoQueryParam]? = nil,
    body: Data? = nil,
    acceptedStatusCodes: [Int] = Array(200...299)
  ) async -> Result<Data, Error> {
    // 1) Verify user and Firebase token
    guard let user = Auth.auth().currentUser else {
      return .failure(LoginError.notLoggedIn)
    }
    let token: String
    do {
      token = try await user.getIDTokenResult().token
      // #if DEBUG
      //   print("Token:\n\(token)")
      // #endif
    } catch {
      return .failure(error)
    }

    // 2) Build URL with query params
    let finalUrlResult = buildURL(for: path, with: queryParams)
    let finalURL: URL
    switch finalUrlResult {
    case .failure(let error):
      print("Error building URL: \(error)")
      return .failure(error)
    case .success(let result):
      finalURL = result
    }

    // 3) Configure URLRequest
    var request = URLRequest(url: finalURL)
    request.httpMethod = method.rawValue
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//    #if DEBUG
//      print("Request URL: \(request)")
//    #endif

    if let body = body {
      request.httpBody = body
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    // 4) Call URLSession
    do {
      let (data, response) = try await session.data(for: request)

//    #if DEBUG
//      print("Response:\n\(String(decoding: data, as: UTF8.self))")
//    #endif

      // 5) Verify status code
      if let httpResponse = response as? HTTPURLResponse {
        if !acceptedStatusCodes.contains(httpResponse.statusCode) {
          return .failure(URLError(.badServerResponse))
        }
      }
      return .success(data)
    } catch {
      return .failure(error)
    }
  }

  private func buildURL(
    for path: MovsyGoPaths, with queryParams: [MovsyGoQueryParam]?
  ) -> Result<URL, Error> {
    guard let urlBase,
      var components = URLComponents(
        string: "\(urlBase)\(path.stringValue)")
    else {
      return .failure(URLError(.badURL))
    }
    
    if let queryParams = queryParams, !queryParams.isEmpty {
      components.queryItems = (components.queryItems ?? []) + queryParams.urlQueryItems
    }

    guard let finalURL = components.url else {
      return .failure(URLError(.badURL))
    }
    return .success(finalURL)
  }
}
