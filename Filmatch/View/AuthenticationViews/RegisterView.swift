//
//  RegisterView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

import SwiftUI

/// `RegisterView` is a SwiftUI view that provides a registration form for new users.
/// It includes fields for email, password, and password confirmation, along with validation logic.
/// The view also handles navigation to the login screen and supports external authentication providers.
struct RegisterView: View {
  /// The minimum length required for the password.
  let passwordMinLength: Int = 8
  
  /// The title displayed at the top of the registration form.
  var title: LocalizedStringResource = "Get started"
  
  /// The authentication view model responsible for handling authentication-related actions.
  var authVm: AuthenticationViewModel
  
  /// An instance of `ValidationHelper` used for validating input fields.
  var helper = ValidationHelper()
  
  /// Binding to control the current authentication sheet view (e.g., login or register).
  @Binding var authSheetView: AuthenticationSheetView?
  
  /// The email entered by the user.
  @State private var email = ""
  
  /// Validation errors for the email field.
  @State private var emailErrors: [LocalizedStringResource]?
  
  /// The password entered by the user.
  @State private var password = ""
  
  /// Validation errors for the password field.
  @State private var passwordErrors: [LocalizedStringResource]?
  
  /// The password confirmation entered by the user.
  @State private var passwordConfirmation = ""
  
  /// Validation errors for the password confirmation field.
  @State private var passwordConfirmationErrors: [LocalizedStringResource]?
  
  /// The field currently focused in the form.
  @FocusState var focusedField: Field?
  
  /// A computed property to determine if the form is valid.
  private var isFormValid: Bool {
    email.isEmpty ||
    emailErrors != nil ||
    password.isEmpty ||
    passwordErrors != nil ||
    passwordConfirmation.isEmpty ||
    password != passwordConfirmation
  }

  var body: some View {
    VStack(spacing: 10) {
      // Dismiss button to close the registration view
      DismissButton()

      // Title of the registration form
      Text(title)
        .bold()
        .font(.largeTitle)
        .foregroundStyle(.accent)

      ScrollView {
        VStack {
          // MARK: - Form
          VStack(alignment: .leading) {
            // MARK: - Email Field
            // Email input field with validation
            TextFieldWithClearButton(
              hint: "Email",
              field: $email,
              emailErrors: $emailErrors,
              focusedField: $focusedField,
              fieldValue: .email,
              maxHeight: 30
            ) { _, errors in
              helper.combineErrors(startingWith: nil, errors: errors)
            } validate: {
              helper.updateErrorMessage($emailErrors) {
                helper.isEmailValid(email)
              }
            }  // TextField Email

            Divider()

            // MARK: - Password Field
            // TODO: Fix keyboard flickering when focus changes to this field
            /*
             There's some kind of bug with TextFields and SecureFields, probably when they're out of a Form.
             If the next SecureField is changed by a TextField, the flickering happens with the next one (confirmation).
             But if we keep this structure, the confirmation does not trigger the flickering and the pass triggers it again.
             It seems to be a constraints issue related to UIKit.
             */
            SecureFieldWithRevealButton(
              hint: "Password",
              password: $password,
              passwordErrors: $passwordErrors,
              focusedField: $focusedField,
              secureField: .secureField1,
              insecureField: .insecureField1,
              maxHeight: 30,
              startingErrorMessage: "Password must contain at least:"
            ) { startingMessage, errors in
              helper.combineErrors(
                startingWith: password.isEmpty ? nil : startingMessage, errors: errors)
            } validate: {
              helper.updateErrorMessage($passwordErrors) {
                helper.isPasswordValid(password)
              }
            }  // SecureField Password

            Divider()

            // MARK: - Confirm Password Field
            // Password confirmation input field with reveal button and validation.
            SecureFieldWithRevealButton(
              hint: "Confirm Password",
              password: $passwordConfirmation,
              passwordErrors: $passwordConfirmationErrors,
              focusedField: $focusedField,
              secureField: .secureField2,
              insecureField: .insecureField2,
              maxHeight: 30,
              startingErrorMessage: "Password must contain at least:"
            ) { _, errors in
              helper.combineErrors(startingWith: nil, errors: errors)
            } validate: {
              helper.updateErrorMessage($passwordConfirmationErrors) {
                helper.isPasswordConfirmationValid(for: password,
                                                   and: passwordConfirmation)
              }
            }
            .onChange(of: password) {
              // Re-validate password confirmation when the password changes.
              if !passwordConfirmation.isEmpty {
                helper.updateErrorMessage($passwordConfirmationErrors) {
                  helper.isPasswordConfirmationValid(
                    for: password, and: passwordConfirmation)
                }
              }
            }  // SecureField Password
          }  // VStack Form
          .padding()
          .background(.bgBase)
          .clipShape(.rect(cornerRadius: 10))
          .shadow(radius: 5, y: 5)
          .autocorrectionDisabled()
          .textInputAutocapitalization(.never)
        }
        .padding()

        // MARK: - Backend error
        // Display backend error messages if any.
        if let errorMessage = authVm.errorMessage {
          Text(errorMessage)
            .foregroundColor(.red)
        }
        
        // Register button to submit the form.
        Button("Register") {
          authVm.createNewUser(
            email: email.lowercased().trimmingCharacters(
              in: .whitespacesAndNewlines), password: password)
        }
        .buttonStyle(WideButtonStyle())
        .disabled(isFormValid)
      }  // ScrollView

      // MARK: - Footer
      VStack {
        // External authentication providers (e.g., Google, Apple).
        ExternalAuthProvidersView {
          authVm.googleOAuth()
        } onAppleSignIn: {
          // TODO: Implement Apple OAuth
        }
        
        // Navigation to the login view.
        HStack {
          Text("Already have an account?")
            .tint(.black)
          Button {
            authSheetView = .LOGIN
          } label: {
            Text("Login")
          }
        } // HStack Go to login
      }  // VStack Footer
    }  // VStack Base
    .padding()
  }
}

// Disclaimer: This preview modifies the original component in order to
// provide a more comfortable view while building it
#Preview {
  @Previewable @State var vm = AuthenticationViewModel()
  vm.errorMessage = "Sample error message"

  return VStack {
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Gradient(colors: [.accent, .accentDarker]))
  .sheet(isPresented: .constant(true)) {
    RegisterView(authVm: vm, authSheetView: .constant(.REGISTER))
      .presentationDetents([.fraction(0.75)])
  }
}