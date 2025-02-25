//
//  PersonDatasourceImpl.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 2/1/25.
//

import Foundation

final class PersonDatasourceImpl: PersonDatasource {
  private let client: TMDBHttpClient

  init(client: TMDBHttpClient) {
    self.client = client
  }

  func getPerson(byId id: Int) async -> Result<
    PersonDetailSingleResponse, Error
  > {
    let endpoint = "person/\(id)"
    return await client.get(
      endpoint,
      extraQueryItems: [
        URLQueryItem(
          name: QueryParam.appendToResponse.rawValue,
          value: "movie_credits,tv_credits")
      ],
      responseType: PersonDetailSingleResponse.self
    )
  }

  func getPersonMovieCredits(byId id: Int) async -> Result<
    PersonMovieCreditsResponse, any Error
  > {
    let endpoint = "person/\(id)/movie_credits"
    return await client.get(
      endpoint, extraQueryItems: [],
      responseType: PersonMovieCreditsResponse.self)
  }
}
