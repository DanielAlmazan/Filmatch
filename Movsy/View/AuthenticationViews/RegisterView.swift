//
//  RegisterView.swift
//  Movsy
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

  /// Validation errors for the password confirmation field.
  @State private var passwordConfirmationErrors: [LocalizedStringResource]?

  @State private var isTermsAccepted = false

  /// The field currently focused in the form.
  @FocusState var focusedField: Field?

  /// A computed property to determine if the form is valid.
  private var isFormNotValid: Bool {
    email.isEmpty
      || emailErrors != nil
      || password.isEmpty
      || passwordErrors != nil
      || !isTermsAccepted
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
              secureField: .secureField,
              insecureField: .insecureField,
              maxHeight: 30,
              startingErrorMessage: "Password must contain at least:"
            ) { startingMessage, errors in
              helper.combineErrors(
                startingWith: password.isEmpty ? nil : startingMessage,
                errors: errors)
            } validate: {
              helper.updateErrorMessage($passwordErrors) {
                helper.isPasswordValid(password)
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

        // MARK: - Terms and conditions
        Toggle(isOn: $isTermsAccepted) {
          HStack(spacing: 4) {
            Text("I accept the")
            Link("Terms and Conditions", destination: URL(string: "https://catdevs.com/privacy-policy.html")!)
              .underline()
          }
          .font(.footnote)
        }
        .toggleStyle(CheckboxToggleStyle())
        .padding(.horizontal)

        // Register button to submit the form.
        Button("Register") {
          authVm.createNewUser(
            email:
              email
              .lowercased()
              .trimmingCharacters(in: .whitespacesAndNewlines),
            password: password)
        }
        .buttonStyle(WideButtonStyle())
        .disabled(isFormNotValid)
      }  // ScrollView

      // MARK: - Footer
      VStack {
        // External authentication providers (e.g., Google, Apple).
        ExternalAuthProvidersView {
          Task {
            try authVm.googleOAuth()
          }
        } onAppleSignIn: {
          Task {
            try authVm.appleOAuth()
          }
        }

        // Navigation to the login view.
        HStack {
          Text("Already have an account?")
            .tint(.black)
          Button {
            authSheetView = .LOGIN
          } label: {
            Text("Login")
              .bold()
          }
        }  // HStack Go to login
      }  // VStack Footer
    }  // VStack Base
    .padding()
  }
}

// Disclaimer: This preview modifies the original component in order to
// provide a more comfortable view while building it
#Preview {
  @Previewable @State var vm = AuthenticationViewModel(
    authenticationRepository: AuthenticationFirebaseRepository(
      dataSource: AuthenticationFirebaseDataSource()
    ),
        movsyRepository: MovsyGoRepositoryImpl(
      datasource: MovsyGoDatasourceImpl(
        client: MovsyHttpClient(
          urlBase: API.movsyBaseURL)
      )
    )
  )
  
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
