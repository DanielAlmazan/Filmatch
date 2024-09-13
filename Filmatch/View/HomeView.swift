//
//  HomeView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import SwiftUI

struct HomeView: View {
    @State var showingProfile = false
    
    var body: some View {
        NavigationSplitView {
            List {
                
            }
            .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: $showingProfile) {
            }

        } detail: {
            Text("Select an option")
        }
    }
}

#Preview {
    HomeView()
}
