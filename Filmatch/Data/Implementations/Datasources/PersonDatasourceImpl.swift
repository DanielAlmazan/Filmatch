//
//  PersonDatasourceImpl.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 2/1/25.
//

import Foundation

final class PersonDatasourceImpl: PersonDatasource {
  private let client: HttpClient
  
  init(client: HttpClient) {
    self.client = client
  }
  
  func getPerson(byId id: Int) async -> Result<
    PersonDetailSingleResponse, Error
  > {
    let endpoint = "/person/\(id)"
    return await client.get(
      endpoint,
      extraQueryItems: [],
      responseType: PersonDetailSingleResponse.self
    )
  }
}
