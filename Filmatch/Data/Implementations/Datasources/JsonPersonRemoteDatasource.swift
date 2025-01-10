//
//  JsonPersonRemoteDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 4/1/25.
//

import Foundation

final class JsonPersonRemoteDatasource: PersonDatasource {
  let client: JsonClient = JsonClient()

  func getPerson(byId id: Int) async -> Result<PersonDetailSingleResponse, any Error> {
    await client.get("person-\(id)-append_to_response-movie_credits",
                     extraQueryItems: [],
                     responseType: PersonDetailSingleResponse.self,
                     acceptanceRange: nil
    )
  }
}
