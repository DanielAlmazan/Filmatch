//
//  FilmatchHttpClient.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 26/1/25.
//

import FirebaseAuth
import Foundation

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
    // 1) Verify user and Firebase token
    guard let user = Auth.auth().currentUser else {
      return .failure(LoginError.notLoggedIn)
    }
    let token: String
    do {
      token = try await user.getIDTokenResult().token
      #if DEBUG
        print("Token:\n\(token)")
      #endif
    } catch {
      return .failure(error)
    }

    // 2) Build URL with query params
    guard
      var components = URLComponents(
        string: "\(self.urlBase)\(path.stringValue)")
    else {
      return .failure(URLError(.badURL))
    }
    if let queryParams = queryParams, !queryParams.isEmpty {
      var items = [URLQueryItem]()
      for (key, value) in queryParams {
        items.append(URLQueryItem(name: key, value: value))
      }
      components.queryItems = (components.queryItems ?? []) + items
    }

    guard let finalURL = components.url else {
      return .failure(URLError(.badURL))
    }

    // 3) Configure URLRequest
    var request = URLRequest(url: finalURL)
    request.httpMethod = method.rawValue
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    if let body = body {
      request.httpBody = body
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }

    // 4) Call URLSession
    do {
      let (data, response) = try await session.data(for: request)
      
      print("Response: \(String(decoding: data, as: UTF8.self))")

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
}
