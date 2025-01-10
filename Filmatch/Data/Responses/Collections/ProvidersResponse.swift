//
//  ProvidersResponse.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import Foundation

/// `ProvidersResponse` represents the response from an API call fetching movie providers.
/// It contains a list of `MovieProvider` objects.
final class ProvidersResponse: Codable {
  /// An array of movie providers.
  let results: [StreamingProviderSingleResponse]
}
