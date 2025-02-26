//
//  NetworkModel.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 6/1/25.
//

import Foundation

final class NetworkModel: Identifiable, Sendable {
  let id: Int
  let logoPath: String?
  let name: String?
  let originCountry: String?

  init(id: Int, logoPath: String?, name: String?, originCountry: String?) {
    self.id = id
    self.logoPath = logoPath
    self.name = name
    self.originCountry = originCountry
  }
}

extension NetworkModel: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case logoPath = "logo_path"
    case name
    case originCountry = "origin_country"
  }

  convenience init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let id = try container.decode(Int.self, forKey: .id)
    let logoPath = try container.decodeIfPresent(String.self, forKey: .logoPath)
    let name = try container.decodeIfPresent(String.self, forKey: .name)
    let originCountry = try container.decodeIfPresent(
      String.self, forKey: .originCountry)

    self.init(
      id: id, logoPath: logoPath, name: name, originCountry: originCountry)
  }

  func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(id, forKey: .id)
    try container.encodeIfPresent(logoPath, forKey: .logoPath)
    try container.encodeIfPresent(name, forKey: .name)
    try container.encodeIfPresent(originCountry, forKey: .originCountry)
  }
}

extension NetworkModel: Equatable {
  static func == (lhs: NetworkModel, rhs: NetworkModel) -> Bool {
    lhs.id == rhs.id
  }
}

extension NetworkModel: CustomStringConvertible {
  var description: String {
    "NetworkModel(id: \(id), logoPath: \(logoPath ?? "No logoPath"), name: \(name ?? "No name"), originCountry: \(originCountry ?? "No originCountry"))"
  }
}
