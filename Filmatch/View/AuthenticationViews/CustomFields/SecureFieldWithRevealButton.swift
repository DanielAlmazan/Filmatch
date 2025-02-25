//
//  SecureFieldWithRevealButton.swift
//  OtterMatch
//
//  Created by Daniel Enrique Almazán Sellés on 23/10/24.
//

import SwiftUI

/// `SecureFieldWithRevealButton` is a view that provides a password input field with an option to reveal or hide the entered text. It includes validation and displays error messages when necessary.
struct SecureFieldWithRevealButton: View {
  /// The hint to show in the field.
  let hint: LocalizedStringResource

  /// The password entered by the user.
  @Binding var password: String
  
  /// Validation errors for the password.
  @Binding var passwordErrors: [LocalizedStringResource]?
  
  @State var isDirty: Bool = false
  
  /// The currently focused field.
  var focusedField: FocusState<Field?>.Binding
  
  /// Identifier for the secure field (when the password is hidden).
  let secureField: Field?
  
  /// Identifier for the insecure field (when the password is visible).
  let insecureField: Field?
  
  /// Maximum height of the input field.
  let maxHeight: CGFloat
  
  /// Initial message to display before password errors.
  let startingErrorMessage: LocalizedStringResource?
  
  /// Function to generate the text for password errors.
  let getPasswordErrors:
  ((LocalizedStringResource?, [LocalizedStringResource]) -> AnyView)?
  
  /// Validation function to execute when values change.
  let validate: () -> Void

  /// State indicating whether the field is secure (hidden) or revealed (visible).
  @State private var isSecured = true

  var body: some View {
    VStack(alignment: .leading) {
      // MARK: - Field
      HStack(spacing: 10) {
        Group {
          if isSecured {
            // Secure input field for the password (hidden text)
            SecureField(hint.key, text: $password)
              .focused(focusedField, equals: secureField)
          } else {
            // Text input field for the revealed password (visible text)
            TextField(hint.key, text: $password)
              .focused(focusedField, equals: insecureField)
          }
        }
        .textContentType(.password)
        .onChange(of: password) {
          // Executes validation when the password changes
          if isDirty && !password.isEmpty{
            validate()
          }
        }
        .onChange(of: focusedField.wrappedValue) { oldValue, newValue in
          // Executes validation when the field looses focus
          if oldValue == .secureField || oldValue == .insecureField {
            validate()
          }
          
          if let newValue, newValue != .secureField && newValue != .insecureField {
            isDirty = true
          }
        } // Group Fields

        // MARK: - Button
        // Button to toggle visibility of the password
        Button {
          isSecured.toggle()
          focusedField.wrappedValue = isSecured ? secureField : insecureField
        } label: {
          Image(systemName: isSecured ? "eye.slash" : "eye")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: maxHeight) // Needed to keep the proportions between the two images
            .contentTransition(.symbolEffect(.replace))
            .foregroundStyle(password.isEmpty ? .secondary : .primary)
        } // Button Visibility toggle and focus reassigning
      } // HStack Field
      .padding(5)
      .frame(maxHeight: maxHeight)

      // MARK: - Errors
      // Displays password errors if they exist
      if let passwordErrors {
        getPasswordErrors?(startingErrorMessage, passwordErrors)
          .font(.caption)
          .foregroundColor(.red)
          .padding(.horizontal, 5)
      }
    } // VStack Base
  }
}

// Disclaimer: This preview modifies the original component in order to
// provide a more comfortable view while building it
#Preview {
  @Previewable @State var password: String = "user@host.domain"
  @Previewable @State var passwordErrors: [LocalizedStringResource]? = []
  @FocusState var focus: Field?

  VStack {
    SecureFieldWithRevealButton(
      hint: "Password",
      password: $password,
      passwordErrors: $passwordErrors,
      focusedField: $focus,
      secureField: .secureField,
      insecureField: .insecureField,
      maxHeight: 30,
      startingErrorMessage: nil,
      getPasswordErrors: {_,_ in
        let sampleErrorMessage = "Password is too short."
        return AnyView(Text(sampleErrorMessage))
      }, validate: {
        print("Validating password: \(password)")
      }
    )
    .padding()
    .background(.bgBase)
    .clipShape(.rect(cornerRadius: 10))
  }
  .padding()
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Gradient(colors: [.accent, .accentDarker]))
}
