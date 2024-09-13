//
//  CastItem.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 18/8/24.
//

import Foundation

final class CastMember: Identifiable, Codable {
    let id: Int
    let adult: Bool
    let gender: Gender
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let castId: Int
    let character: String
    let creditId: String
    let order: Int
    
    init(id: Int, adult: Bool, gender: Gender, knownForDepartment: String, name: String, originalName: String, popularity: Double, profilePath: String?, castId: Int, character: String, creditId: String, order: Int) {
        self.id = id
        self.adult = adult
        self.gender = gender
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.castId = castId
        self.character = character
        self.creditId = creditId
        self.order = order
    }

    enum CodingKeys: String, CodingKey {
        case id, adult, gender, name, popularity, character, order
        case knownForDepartment = "known_for_department"
        case originalName = "original_name"
        case profilePath = "profile_path"
        case castId = "cast_id"
        case creditId = "credit_id"
    }
    
    static let `default` = CastMember(id: 26723, adult: false, gender: Gender.female, knownForDepartment: "Acting", name: "Katheryn Winnick", originalName: "Katheryn Winnick", popularity: 111.311, profilePath: "/vQSqH3ybDWZHZIqX4NZKhOCXAhQ.jpg", castId: 12, character: "Vivian", creditId: "5a95d69392514154ed006aa8", order: 2)
}

extension CastMember: CustomStringConvertible {
    var description: String {
        return """
               CastMember:
                   - id: \(id)
                   - adult: \(adult)
                   - gender: \(gender)
                   - knownForDepartment: \(knownForDepartment)
                   - name: \(name)
                   - originalName: \(originalName)
                   - popularity: \(popularity)
                   - profilePath: \(profilePath ?? "No profile photo")
                   - castId: \(castId)
                   - character: \(character)
                   - creditId: \(creditId)
                   - order: \(order)
               """
    }
}
