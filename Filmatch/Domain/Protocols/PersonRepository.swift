//
//  PersonRepository.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 1/1/25.
//

import Foundation

protocol PersonRepository {
  func getPerson(byId id: Int) async -> Result<PersonDetailSingleResponse, any Error>
  func getPersonMovieCredits(byId id: Int) async -> Result<PersonMovieCreditsResponse, any Error>
}
