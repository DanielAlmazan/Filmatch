//
//  Genre.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation

final class Genre: Identifiable, Sendable {
  let id: Int
  let name: String?

  init(id: Int, name: String?) {
    self.id = id
    self.name = name
  }
}

extension Genre: Codable {
  enum CodingKeys: String, CodingKey {
    case id, name
  }

  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let id = try container.decode(Int.self, forKey: .id)
    let name = try container.decodeIfPresent(String.self, forKey: .name)

    self.init(id: id, name: name)
  }
}

extension Genre {
  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
  }
}

extension Genre: Equatable {
  static func == (lhs: Genre, rhs: Genre) -> Bool {
    lhs.id == rhs.id
      && lhs.name == rhs.name
  }
}

extension [Genre] {
  func toUrlQueryItem(separator: QueryParamSeparator) -> URLQueryItem {
    let genres = self.map { "\($0.id)" }.joined(separator: separator.rawValue)

    return .init(name: QueryParam.withGenres.rawValue, value: "\(genres)")
  }
}

extension Genre: CustomStringConvertible {
  var description: String {
    return """
      Genre:
        - id: \(id)
        - name: \(name ?? "nil")

      """
  }
}
