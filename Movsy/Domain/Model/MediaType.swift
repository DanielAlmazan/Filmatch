//
//  MediaType.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 23/12/24.
//

import Foundation

enum MediaType: String, CaseIterable, Identifiable {
  var id: Self { self }
  
  case movie = "movie"
  case tvSeries = "tv"
}
