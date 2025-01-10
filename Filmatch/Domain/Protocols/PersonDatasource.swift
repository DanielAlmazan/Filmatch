//
//  PersonDatasource.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 1/1/25.
//

import Foundation

protocol PersonDatasource {
  func getPerson(byId id: Int) async -> Result<PersonDetailSingleResponse, any Error>
}
