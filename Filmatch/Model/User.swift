//
//  User.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/7/24.
//

import Foundation
import SwiftUI

struct User {
    let name: String
    let surname: String
    let email: String
    let birthdate = Date()
    let image: Image = Image(systemName: "person.circle")
    let providers: [MovieProvider]
    
    static let `default` = User(
        name: "Anaclet",
        surname: "Agente Secreto",
        email: "anaclet@secret.com",
        providers: [
            MovieProvider(providerId: 350, providerName: "Apple TV Plus", logoPath: "/2E03IAZsX4ZaUqM7tXlctEPMGWS.jpg", displayPriority: 9, displayPriorities: ["AE": 2, "AG": 12, "AR": 5, "AT": 5, "AZ": 3, "AU": 11, "BE": 9, "BG": 3, "BO": 3, "BH": 50,]),
            MovieProvider(providerId: 337, providerName: "Disney Plus", logoPath: "/97yvRBw1GzX7fXprcF80er19ot.jpg", displayPriority: 28, displayPriorities: ["AD": 7, "AL": 7, "AR": 0])
        ])
}
