//
//  RoomsMainView.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 1/10/24.
//

import SwiftUI

struct RoomsMainView: View {
  @State var selectedRoom: Int?
  @State var showPicker: Bool = false
  
  var body: some View {
    NavigationStack {
      VStack {
        VStack {
          Text("Create Room")

          Image(systemName: "plus")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.gray)
        .clipShape(.rect(cornerRadius: 20))

        VStack {
          Label("Select room", systemImage: "person.3.fill")
            .onTapGesture {
              showPicker.toggle()
            }
            .popover(isPresented: $showPicker) {
            }
          Picker("Select room", selection: $selectedRoom) {
            ForEach(1...10, id: \.self) { number in
              Text(number.description)
            }
          }
          .pickerStyle(.wheel)
          
          Text("Join room")

          Image(systemName: "person.3.fill")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(.gray)
        .clipShape(.rect(cornerRadius: 20))
      }
      .padding()
      .navigationTitle("Rooms")
    }
  }
}

#Preview {
  RoomsMainView()
}
