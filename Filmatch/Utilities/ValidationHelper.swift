//
//  ValidationHelper.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 21/10/24.
//

import Foundation
import SwiftUI

/// `Field` is an enumeration that represents the different input fields in the app.
/// It conforms to `Hashable` to be used in focus management and state tracking.
enum Field: Hashable {
  case email, secureField1, secureField2, insecureField1, insecureField2
}

/// `ValidationHelper` is a struct that provides validation logic for user input fields such as email and password.
/// It includes regular expressions and methods to validate inputs and generate error messages.
struct ValidationHelper {
  /// The regular expression pattern used to validate email addresses.
  let emailRegex: String
  
  /// The minimum required length for passwords.
  let minLength: Int
  
  /// The regular expression pattern used to validate passwords.
  let passwordRegex: String
  
  /// Initializes a new `ValidationHelper` with an optional minimum password length.
  /// - Parameter minLength: The minimum length required for passwords. Defaults to 8.
  init(passwordMinLength minLength: Int = 8) {
    self.minLength = minLength
    self.emailRegex = "^[a-zA-Z][a-z0-9!#$%&'*+/=?^_`{|}~-]*(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@[a-z0-9](?:[a-z0-9-]*[a-z0-9])?(?:\\.[a-z0-9](?:[a-z0-9-]*[a-z0-9])?)+$"
    self.passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\W)(?=.*\\d).{\(minLength),}$"
  }

  /// Validates an email address and returns an array of error messages if invalid.
  /// - Parameter email: The email address to validate.
  /// - Returns: An array of `LocalizedStringResource` containing error messages, or `nil` if valid.
  func isEmailValid(_ email: String) -> [LocalizedStringResource]? {
    let email = email.trimmingCharacters(in: .whitespacesAndNewlines)

    return email.isEmpty
      ? ["Email is required"]
      : !self.isValidEmail(email)
        ? ["Please, enter a valid email"]
        : nil
  }

  /// Checks if an email address matches the email regular expression pattern.
  /// - Parameter email: The email address to check.
  /// - Returns: `true` if the email is valid, `false` otherwise.
  func isValidEmail(_ email: String) -> Bool {
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", self.emailRegex)
    return emailPredicate.evaluate(with: email)
  }

  /// Validates a password and returns an array of error messages indicating validation failures.
  /// - Parameters:
  ///   - password: The password to validate.
  ///   - minLength: The minimum length required for the password. Defaults to 8.
  /// - Returns: An array of `LocalizedStringResource` containing error messages, or `nil` if valid.
  func isPasswordValid(_ password: String, minLength: Int = 8)
    -> [LocalizedStringResource]?
  {
    var errorMessages: [LocalizedStringResource] = []

    if password.isEmpty {
      errorMessages.append("Password is required")
    } else {
      let passwordPredicate = NSPredicate(
        format: "SELF MATCHES %@", passwordRegex)

      if !passwordPredicate.evaluate(with: password) {
        if password.count < minLength {
          errorMessages.append(
            LocalizedStringResource(" \(minLength - password.count) more characters", comment: "Full sentence could be \"Password must contain at least 8 characters.\""))
        }
        if !password.contains(where: { $0.isUppercase }) {
          errorMessages.append(
            LocalizedStringResource(" one uppercase letter", comment: "Full sentence could be \"Password must contain at least one uppercase letter.\""))
        }
        if !password.contains(where: { $0.isLowercase }) {
          errorMessages.append(
            LocalizedStringResource(" one lowercase letter", comment: "Full sentence could be \"Password must contain at least one lowercase letter.\""))
        }
        if !password.contains(where: { $0.isNumber }) {
          errorMessages.append(LocalizedStringResource(" one number", comment: "Full sentence could be \"Password must contain at least one number."))
        }
        if !password.contains(where: { !$0.isLetter && !$0.isNumber }) {
          errorMessages.append(
            LocalizedStringResource(" one non-alphanumeric character", comment: "Full sentence could be \"Password must contain at least one non-alphanumeric character."))
        }
      }
    }

    return errorMessages.isEmpty ? nil : errorMessages
  }
  
  /// Combines multiple error messages into a single `Text` view, optionally prefixed by a field name.
  /// - Parameters:
  ///   - header: An optional `LocalizedStringResource` representing the starting message.
  ///   - errors: An array of error messages to combine.
  /// - Returns: A `Text` view containing the combined error messages.
  func combineErrors(startingWith header: LocalizedStringResource?, errors: [LocalizedStringResource]) -> AnyView {
    AnyView(
      VStack(alignment: .leading, spacing: 4) {
        if let header = header {
          Text(header)
        }
        
        ForEach(errors.indices, id: \.self) { index in
          Text(errors[index])
            .padding(.leading, header != nil ? 10 : 0)
        }
      }
      .font(.caption)
      .foregroundColor(.red)
    )
  }
  
//    return errors
//      .map { Text($0) }
//      .reduce(Text("\(header)"), { result, next in
//        result + Text("\n\t") + next
//      })
  
  
  /// Validates that the password confirmation matches the original password.
  /// - Parameters:
  ///   - password: The original password.
  ///   - confirmPassword: The password confirmation to validate.
  /// - Returns: An array containing an error message if the passwords do not match, or `nil` if they match.
  func isPasswordConfirmationValid(for password: String, and confirmPassword: String) -> [LocalizedStringResource]? {
    password == confirmPassword ? nil : ["Passwords do not match"]
  }
  
  /// Updates the error message binding with the result of a validation function, with an animation.
  /// - Parameters:
  ///   - errorMessage: A binding to the error message variable to update.
  ///   - validator: A closure that performs validation and returns an optional error message.
  func updateErrorMessage<E>(_ errorMessage: Binding<E?>, validator: () -> E?) {
    withAnimation {
      errorMessage.wrappedValue = validator()
    }
  }
}
