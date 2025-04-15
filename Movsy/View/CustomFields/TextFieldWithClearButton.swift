//
//  TextFieldWithClearButton.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 23/10/24.
//

import SwiftUI

/// `TextFieldWithClearButton` is a SwiftUI view that provides a text field
/// with a clear button and error handling.
/// This view is typically used for input fields like email addresses, where
/// the user can quickly clear the input and see validation errors.
struct TextFieldWithClearButton: View {
  /// The placeholder text displayed in the text field.
  let hint: LocalizedStringResource
  
  /// Binding to the text input of the field.
  @Binding var field: String
  
  /// Validation errors associated with the field.
  @Binding var emailErrors: [LocalizedStringResource]?
  
  /// The binding to manage focus state of the field.
  var focusedField: FocusState<Field?>.Binding
  
  @State var isDirty: Bool = false
  
  /// The specific field value used for focus management.
  let fieldValue: Field?
  
  /// The maximum height of the text field.
  let maxHeight: CGFloat
  
  /// Function to generate the text for error messages.
  let getPasswordErrors: ((LocalizedStringResource?, [LocalizedStringResource]) -> AnyView)?
  
  /// Validation function executed when the field value changes or focus changes.
  let validate: () -> Void
  
  var body: some View {
    VStack(alignment: .leading) {
      // MARK: - Field
      HStack(spacing: 10) {
        // MARK: - TextField
        TextField(hint.key, text: $field)
          .keyboardType(.emailAddress)
          .textContentType(.emailAddress)
          .focused(focusedField, equals: fieldValue)
          .onChange(of: field) {
            // Execute validation when the field value changes
            if isDirty && !field.isEmpty {
              validate()
            }
          }
          .onChange(of: focusedField.wrappedValue) { oldValue, newValue in
            // Executes validation when the field looses focus
            if let oldValue, oldValue == .email {
              validate()
            }
            
            if let newValue, newValue != .email {
              isDirty = true
            }
          } // TextField
        
        // MARK: - Clear Button
        if !field.isEmpty {
          // Button to clear the text field.
          Button {
            field.removeAll()
          }label: {
            Image(systemName: "multiply.circle.fill")
              .resizable()
              .scaledToFit()
              .symbolEffect(.bounce, options: .nonRepeating)
          }
        } // Clear Button
      } // HStack Field
      .padding(5)
      .frame(maxHeight: maxHeight)
      
      
      // MARK: - Email Error
      if let emailErrors {
        // Display validation errors if they exist.
        getPasswordErrors?(nil, emailErrors)
          .font(.caption)
          .foregroundStyle(.red)
          .padding(.horizontal, 5)
      }  // if let emailError
    } // VStack Base
  }
}

// Disclaimer: This preview modifies the original component in order to
// provide a more comfortable view while building it
#Preview {
  @Previewable @State var email: String = "user@host.domain"
  @Previewable @State var emailErrors: [LocalizedStringResource]? = ["Sample error"]
  @FocusState var focus: Field?

  VStack {
    TextFieldWithClearButton(
      hint: "Email",
      field: $email,
      emailErrors: $emailErrors,
      focusedField: $focus,
      fieldValue: .email,
      maxHeight: 30,
      getPasswordErrors: {_,_ in
        AnyView (
          Text("Sample error message")
        )
      },
      validate: {
      
    })
      .padding()
      .background(.bgBase)
      .clipShape(.rect(cornerRadius: 10))
  }
  .padding()
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Gradient(colors: [.accent, .accentDarker]))
}
