//
//  FiltersProvidersResponse.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/8/24.
//

import Foundation

/// `FiltersProvidersResponse` represents the response from an API call fetching movie providers.
/// It contains a list of `MovieProvider` objects.
final class FiltersProvidersResponse: Codable {
  /// An array of movie providers.
  let results: [FiltersStreamingProviderSingleResponse]
}
