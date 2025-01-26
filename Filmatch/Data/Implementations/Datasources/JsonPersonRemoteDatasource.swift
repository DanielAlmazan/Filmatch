//
//  JsonPersonRemoteDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 4/1/25.
//

import Foundation

final class JsonPersonRemoteDatasource: PersonDatasource {
  let client: TMDBJsonClient = TMDBJsonClient()

  func getPerson(byId id: Int) async -> Result<PersonDetailSingleResponse, any Error> {
    await client.get("person-\(id)-append_to_response-movie_credits-tv_credits",
                     extraQueryItems: [],
                     responseType: PersonDetailSingleResponse.self,
                     acceptanceRange: nil
    )
  }
  
  func getPersonMovieCredits(byId id: Int) async -> Result<PersonMovieCreditsResponse, any Error> {
    await client.get("person-\(id)-movie_credits",
                     extraQueryItems: [],
                     responseType: PersonMovieCreditsResponse.self,
                     acceptanceRange: nil
    )
  }
}
