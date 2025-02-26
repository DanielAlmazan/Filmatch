//
//  LoginView.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 24/9/24.
//

import SwiftUI

/// `LoginView` is a SwiftUI view that provides a user interface for logging into the app.
/// It includes input fields for email and password, handles validation, and provides options for external authentication.
struct LoginView: View {
  /// The minimum required length for the password.
  let passwordMinLength: Int = 8

  /// The title displayed at the top of the login view.
  var title: LocalizedStringResource = "Welcome Back"
  
  /// Indicates whether the view is being used for re-authentication.
  /// If the user needs to remove the account, it is necessary to
  /// authenticate again.
  var isReAuthentication = false

  /// The authentication view model responsible for handling authentication actions.
  var authVm: AuthenticationViewModel
  
  /// An instance of `ValidationHelper` used for validating input fields.
  var helper = ValidationHelper()

  /// Binding to control the current authentication sheet view (e.g., login or register).
  @Binding var authSheetView: AuthenticationSheetView?

  /// The email entered by the user.
  @State private var email: String = ""
  
  /// Validation errors for the email field.
  @State private var emailErrors: [LocalizedStringResource]?
  
  /// The password entered by the user.
  @State private var password: String = ""
  
  /// Validation errors for the password field.
  @State private var passwordErrors: [LocalizedStringResource]?
  
  /// State to control whether the password is showing or hidden.
  @State private var isPasswordShowing: Bool = false
  
  /// The field currently focused in the form.
  @FocusState private var focusedField: Field?
  
  /// A computed property to determine if the form is valid.
  private var isFormValid: Bool {
    email.isEmpty || emailErrors != nil || password.isEmpty || passwordErrors != nil
  }

  var body: some View {
    VStack(spacing: 10) {
      // Dismiss button to close the login view.
      DismissButton()
      
      // Title of the login view.
      Text(title)
        .bold()
        .font(.largeTitle)
        .multilineTextAlignment(.center)
        .foregroundStyle(.accent)

      ScrollView {
        VStack {
          // MARK: - Form
          VStack {
            // MARK: - Email Field
            // Email input field with a clear button and validation.
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
            // Password input field with a reveal button and validation.
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
                startingWith: password.isEmpty ? nil : startingMessage, errors: errors)
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

        // Login button to submit the form.
        Button("Login") {
          authVm.logIn(
            email: email.lowercased().trimmingCharacters(
              in: .whitespacesAndNewlines), password: password)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
        .background(.accent)
        .clipShape(.capsule)
        .padding(.horizontal)
        .tint(.white)
        .disabled(isFormValid)
      }  // ScrollView

      VStack {
        // MARK: - External authentication providers.
        ExternalAuthProvidersView {
          do {
            try authVm.googleOAuth()
          } catch {
            // TODO: Handle error
          }
        } onAppleSignIn: {
          do {
            try authVm.appleOAuth()
          } catch {
            // TODO: Handle error
          }
        }

        if !isReAuthentication {
          // Navigation to the registration view.
          HStack {
            Text("Don't have an account?")
            Button {
              authSheetView = .REGISTER
            } label: {
              Text("Register")
            }
          }
        }  // End of re-authentication check
      }  // VStack External Providers
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
    otterMatchRepository: OtterMatchGoRepositoryImpl(
      datasource: OtterMatchGoDatasourceImpl(
        client: OtterMatchHttpClient(
          urlBase: API.otterMatchBaseURL)
      )
    )
  )

  vm.errorMessage = "Error message sample"

  return VStack {
  }
  .frame(maxWidth: .infinity, maxHeight: .infinity)
  .background(Gradient(colors: [.accent, .accentDarker]))
  .sheet(isPresented: .constant(true)) {
    LoginView(authVm: vm, authSheetView: .constant(.LOGIN))
      .presentationDetents([.fraction(0.75)])
  }
}
