//
//  ProfileDetails.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import SwiftUI

struct ProfileTab: View {
    @Environment(\.editMode) var editMode
    @State var user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                if editMode?.wrappedValue == .active {
                    Button("Cancel", role: .cancel) {
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }
            
            if editMode?.wrappedValue == .inactive {
                
            }
        }
        .padding()
    }
}

#Preview {
    ProfileTab(user: User.default)
}
