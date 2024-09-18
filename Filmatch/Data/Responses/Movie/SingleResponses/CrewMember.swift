//
//  CrewMember.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 19/8/24.
//

import Foundation

final class CrewMember: Identifiable, Codable, Sendable {
    let id: Int
    let adult: Bool
    let gender: Gender
    let knownForDepartment: String
    let name: String
    let originalName: String
    let popularity: Double
    let profilePath: String?
    let creditId: String
    let department: String
    let job: String
    
    init(id: Int, adult: Bool, gender: Gender, knownForDepartment: String, name: String, originalName: String, popularity: Double, profilePath: String?, creditId: String, department: String, job: String) {
        self.id = id
        self.adult = adult
        self.gender = gender
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.creditId = creditId
        self.department = department
        self.job = job
    }

    enum CodingKeys: String, CodingKey {
        case id
        case adult
        case gender
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case creditId = "credit_id"
        case department
        case job
    }
}

extension CrewMember: CustomStringConvertible {
    var description: String {
        """
        CrewMember:
         - id: \(id)
         - adult: \(adult)
         - gender: \(gender)
         - knownForDepartment: \(knownForDepartment)
         - name: \(name)
         - originalName: \(originalName)
         - popularity: \(popularity)
         - profilePath: \(profilePath ?? "No profile photo")
         - creditId: \(creditId)
         - department: \(department)
         - job: \(job)
        """
    }
}
