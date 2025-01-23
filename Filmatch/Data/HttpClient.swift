//
//  HttpClient.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/12/24.
//

import Foundation

final class HttpClient: Client {
  let urlBase: String

  /// The API key required for TMDb API authentication.
  private let apiKey: String = Config.shared.apiKey

  /// The access token for authentication (if needed).
  private let accessTokenAuth: String = Config.shared.accessTokenAuth

  /// An array of common query items added to every request.
  private var queryItems: [URLQueryItem]

  init(urlBase: String = AppConstants.urlBase) {
    self.urlBase = urlBase
    let language = "\(Locale.preferredLanguages.first ?? "en-US")"
    let watchRegion = "\(Locale.current.region ?? "US")"

    queryItems = [
      URLQueryItem(name: QueryParam.language.rawValue, value: language),
      URLQueryItem(name: QueryParam.apiKey.rawValue, value: apiKey),
      URLQueryItem(name: QueryParam.watchRegion.rawValue, value: watchRegion),
    ]
  }

  func get<T: Decodable>(
    _ endpoint: String,
    extraQueryItems: [URLQueryItem],
    responseType: T.Type,
    acceptanceRange: Range<Int>? = 200..<300
  ) async -> Result<T, Error> {
    print("Requesting \(endpoint)")

    guard let url = URL(string: "\(urlBase)\(endpoint)") else {
      return .failure(URLError(.badURL))
    }

    guard
      var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    else {
      print("Error creating URLComponents")
      return .failure(URLError(.badURL))
    }

    let allQueryItems = queryItems + extraQueryItems
    components.queryItems =
      components.queryItems.map { $0 + allQueryItems } ?? allQueryItems

    guard let componentsUrl = components.url else {
      print("Error creating URL")
      return .failure(URLError(.badURL))
    }

    var request = URLRequest(url: componentsUrl)
    request.httpMethod = HTTPMethods.GET.rawValue
    request.timeoutInterval = 10
    request.allHTTPHeaderFields = [
      "accept": "application/json"
    ]

    do {
      print(request)
      // Proceed to make the request
      let (data, response) = try await URLSession.shared.data(for: request)

      let result = try processRequest(data: data, response: response, acceptanceRange: acceptanceRange, responseType: T.self)
      return result
    } catch {
      print("Error decoding: \(error)")
      return .failure(error)
    }
  }

  private func processRequest<T: Decodable>(
    data: Data, response: URLResponse?,
    acceptanceRange: Range<Int>?,
    responseType: T.Type
  ) throws -> Result<T, Error> {
    // Getting the response to check the status code
    guard let httpResponse = response as? HTTPURLResponse else {
      return .failure(URLError(.badServerResponse))
    }

    guard let acceptanceRange, acceptanceRange.contains(httpResponse.statusCode)
    else {
      print("Error: Status Code \(httpResponse.statusCode)")
      return .failure(URLError(.badServerResponse))
    }

//    print("Response: \(String(decoding: data, as: UTF8.self))")

    let decoder = JSONDecoder()

    let decoded = try decoder.decode(responseType.self, from: data)

    return .success(decoded)
  }
}
