//
//  SearchField.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 22/2/25.
//

import SwiftUI

struct SearchField: View {
  @Binding var query: String
  @FocusState var isInputActive: Bool
  
  var onSubmit: () -> Void
  
  var body: some View {
    HStack(spacing: 10) {
      Image(systemName: "magnifyingglass").opacity(0.50)
      
      // MARK: - TextField
      TextField("Search", text: $query)
        .submitLabel(.search)
        .scrollDismissesKeyboard(.immediately)
        .focused($isInputActive)
        .onSubmit {
          onSubmit()
        }
        .toolbar {
          ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Hide", role: .destructive) {
              isInputActive = false
            }
          }
        }
      
      // MARK: - Clear Button
      if !query.isEmpty {
        Button {
          query.removeAll()
        } label: {
          Image(systemName: "multiply.circle.fill")
            .symbolEffect(.bounce, options: .nonRepeating)
        }
      }
    }
    .frame(height: 25)
    .padding(5)
    .background(.bgContainer)
    .clipShape(.rect(cornerRadius: 8))
//    .padding()
  }
}

#Preview {
  @Previewable @State var query = "Test"

  SearchField(query: $query, onSubmit: { print("Searching for \(query)") })
}
