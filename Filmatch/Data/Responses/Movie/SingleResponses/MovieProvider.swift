//
//  MovieProvider.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/7/24.
//

import Foundation

/// `MovieProvider` represents a provider of movies, such as streaming services or rental platforms.
/// It contains information about the provider, including its ID, name, logo, and display priority.
final class MovieProvider: Codable, Sendable {
  /// The unique identifier of the provider.
  let providerId: Int
  /// The name of the provider.
  let providerName: String
  /// The path to the provider's logo image.
  let logoPath: String
  /// The display priority of the provider.
  let displayPriority: Int
  /// A dictionary containing display priorities for different contexts.
  let displayPriorities: [String: Int]
  
  /// Initializes a new `MovieProvider` instance.
  /// - Parameters:
  ///   - providerId: The unique identifier of the provider.
  ///   - providerName: The name of the provider.
  ///   - logoPath: The path to the provider's logo image.
  ///   - displayPriority: The display priority of the provider.
  ///   - displayPriorities: A dictionary containing display priorities for different contexts.
  init(providerId: Int, providerName: String, logoPath: String, displayPriority: Int, displayPriorities: [String: Int]) {
    self.providerId = providerId
    self.providerName = providerName
    self.logoPath = logoPath
    self.displayPriority = displayPriority
    self.displayPriorities = displayPriorities
  }
}

extension MovieProvider {
  enum CodingKeys: String, CodingKey {
    case providerId = "provider_id"
    case providerName = "provider_name"
    case logoPath = "logo_path"
    case displayPriority = "display_priority"
    case displayPriorities = "display_priorities"
  }
}
