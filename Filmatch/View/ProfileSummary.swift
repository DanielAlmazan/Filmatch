//
//  ProfileSummary.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 13/8/24.
//

import SwiftUI

struct ProfileSummary: View {
    var user: User
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(user.name)
                        .bold()
                        .font(.title)
                    
                    Text(user.surname)
                        .font(.caption)
                }
                
                user.image
                    .resizable()
                    .frame(width: 50, height: 50)
            }
        }
    }
}

#Preview {
    ProfileSummary(user: .default)
}
