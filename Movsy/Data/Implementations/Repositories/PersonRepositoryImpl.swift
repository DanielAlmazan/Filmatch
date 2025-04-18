//
//  PersonRepositoryImpl.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 2/1/25.
//

import Foundation
import Observation

@Observable final class PersonRepositoryImpl: PersonRepository {
  let datasource: PersonDatasource

  init(datasource: PersonDatasource) {
    self.datasource = datasource
  }

  func getPerson(byId id: Int) async -> Result<
    PersonDetailSingleResponse, any Error
  > {
    await datasource.getPerson(byId: id)
  }
  
  func getPersonMovieCredits(byId id: Int) async -> Result<PersonMovieCreditsResponse, any Error> {
    await datasource.getPersonMovieCredits(byId: id)
  }
}
