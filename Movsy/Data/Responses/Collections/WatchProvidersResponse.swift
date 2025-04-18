//
//  WatchProvidersResponse.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 16/1/25.
//

import Foundation

final class WatchProvidersResponse: Identifiable, Sendable {
  let id: Int
  let results: WatchProvidersItem?

  var isEmpty: Bool { isFlatrateEmpty && isBuyEmpty && isRentEmpty }
  var isFlatrateEmpty: Bool { results?.flatrate?.isEmpty ?? true }
  var isBuyEmpty: Bool { results?.buy?.isEmpty ?? true }
  var isRentEmpty: Bool { results?.rent?.isEmpty ?? true }

  init(id: Int, results: WatchProvidersItem?) {
    self.id = id
    self.results = results
  }

  static let `default`: WatchProvidersResponse = .init(
    id: 475557,
    results:
      .init(
        link: URL(
          string:
            "https://www.themoviedb.org/movie/475557-joker/watch?locale=ES"),
        buy: [
          .init(
            providerId: 2,
            providerName: "Apple TV",
            logoPath: "/9ghgSC0MA082EL6HLCW3GalykFD.jpg",
            displayPriority: 5),
          .init(
            providerId: 35,
            providerName: "Rakuten TV",
            logoPath: "/bZvc9dXrXNly7cA0V4D9pR8yJwm.jpg",
            displayPriority: 7),
          .init(
            providerId: 3,
            providerName: "Google Play Movies",
            logoPath: "/8z7rC8uIDaTM91X0ZfkRf04ydj2.jpg",
            displayPriority: 15),
          .init(
            providerId: 68,
            providerName: "Microsoft Store",
            logoPath: "/5vfrJQgNe9UnHVgVNAwZTy0Jo9o.jpg",
            displayPriority: 18),
          .init(
            providerId: 10,
            providerName: "Amazon Video",
            logoPath: "/seGSXajazLMCKGB5hnRCidtjay1.jpg",
            displayPriority: 36),

        ],
        rent: [
          .init(
            providerId: 2,
            providerName: "Apple TV",
            logoPath: "/9ghgSC0MA082EL6HLCW3GalykFD.jpg",
            displayPriority: 5),
          .init(
            providerId: 35,
            providerName: "Rakuten TV",
            logoPath: "/bZvc9dXrXNly7cA0V4D9pR8yJwm.jpg",
            displayPriority: 7),
          .init(
            providerId: 3,
            providerName: "Google Play Movies",
            logoPath: "/8z7rC8uIDaTM91X0ZfkRf04ydj2.jpg",
            displayPriority: 15),
          .init(
            providerId: 68,
            providerName: "Microsoft Store",
            logoPath: "/5vfrJQgNe9UnHVgVNAwZTy0Jo9o.jpg",
            displayPriority: 18),
          .init(
            providerId: 10,
            providerName: "Amazon Video",
            logoPath: "/seGSXajazLMCKGB5hnRCidtjay1.jpg",
            displayPriority: 36),

        ],
        flatrate: [
          .init(
            providerId: 8,
            providerName: "Netflix",
            logoPath: "/pbpMk2JmcoNnQwx5JGpXngfoWtp.jpg", displayPriority: 0
          ),
          .init(
            providerId: 119,
            providerName: "Amazon Prime Video",
            logoPath: "/pvske1MyAoymrs5bguRfVqYiM9a.jpg",
            displayPriority: 3),
          .init(
            providerId: 2241,
            providerName: "Movistar Plus+",
            logoPath: "/jse4MOi92Jgetym7nbXFZZBI6LK.jpg",
            displayPriority: 4),
          .init(
            providerId: 149,
            providerName: "Movistar Plus+ Ficción Total ",
            logoPath: "/f6TRLB3H4jDpFEZ0z2KWSSvu1SB.jpg",
            displayPriority: 6),
          .init(
            providerId: 1899,
            providerName: "Max",
            logoPath: "/fksCUZ9QDWZMUwL2LgMtLckROUN.jpg",
            displayPriority: 17),
          .init(
            providerId: 1796,
            providerName: "Netflix basic with Ads",
            logoPath: "/kICQccvOh8AIBMHGkBXJ047xeHN.jpg",
            displayPriority: 62),
        ]
      )
  )
}

extension WatchProvidersResponse: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case results
  }

  convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let id = try container.decode(Int.self, forKey: .id)
    let results = try container.decode(
      [String: WatchProvidersItem].self, forKey: .results)

    let region = "\(Locale.current.region ?? "US")"
    self.init(id: id, results: results[region])
  }
}
