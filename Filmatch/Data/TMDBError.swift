//
//  TMDBError.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 27/8/24.
//

import Foundation

enum TMDBError: Int, Error {
  case success = 1
  case invalidService = 2
  case authenticationFailed = 3
  case invalidFormat = 4
  case invalidParameters = 5
  case invalidId = 6
  case invalidAPIKey = 7
  case duplicateEntry = 8
  case serviceOffline = 9
  case suspendedAPIKey = 10
  case internalError = 11
  case recordUpdated = 12
  case recordDeleted = 13
  case authenticationFailedAgain = 14
  case failed = 15
  case deviceDenied = 16
  case sessionDenied = 17
  case validationFailed = 18
  case invalidAcceptHeader = 19
  case invalidDateRange = 20
  case entryNotFound = 21
  case invalidPage = 22
  case invalidDateFormat = 23
  case requestTimedOut = 24
  case requestCountOverLimit = 25
  case usernameAndPasswordRequired = 26
  case tooManyAppendObjects = 27
  case invalidTimezone = 28
  case confirmActionRequired = 29
  case invalidUsernameOrPassword = 30
  case accountDisabled = 31
  case emailNotVerified = 32
  case invalidRequestToken = 33
  case resourceNotFound = 34
  case invalidToken = 35
  case tokenWithoutWritePermission = 36
  case sessionNotFound = 37
  case noEditPermission = 38
  case resourceIsPrivate = 39
  case nothingToUpdate = 40
  case tokenNotApproved = 41
  case requestMethodNotSupported = 42
  case backendConnectionFailed = 43
  case invalidID = 44
  case userSuspended = 45
  case apiUnderMaintenance = 46
  case invalidInput = 47
  
  var message: String {
    switch self {
      case .success:
        return "Success."
      case .invalidService:
        return "Invalid service: this service does not exist."
      case .authenticationFailed:
        return "Authentication failed: You do not have permissions to access the service."
      case .invalidFormat:
        return "Invalid format: This service doesn't exist in that format."
      case .invalidParameters:
        return "Invalid parameters: Your request parameters are incorrect."
      case .invalidId:
        return "Invalid ID: The pre-requisite ID is invalid or not found."
      case .invalidAPIKey:
        return "Invalid API key: You must be granted a valid key."
      case .duplicateEntry:
        return "Duplicate entry: The data you tried to submit already exists."
      case .serviceOffline:
        return "Service offline: This service is temporarily offline, try again later."
      case .suspendedAPIKey:
        return "Suspended API key: Access to your account has been suspended, contact TMDB."
      case .internalError:
        return "Internal error: Something went wrong, contact TMDB."
      case .recordUpdated:
        return "The item/record was updated successfully."
      case .recordDeleted:
        return "The item/record was deleted successfully."
      case .authenticationFailedAgain:
        return "Authentication failed."
      case .failed:
        return "Failed."
      case .deviceDenied:
        return "Device denied."
      case .sessionDenied:
        return "Session denied."
      case .validationFailed:
        return "Validation failed."
      case .invalidAcceptHeader:
        return "Invalid accept header."
      case .invalidDateRange:
        return "Invalid date range: Should be a range no longer than 14 days."
      case .entryNotFound:
        return "Entry not found: The item you are trying to edit cannot be found."
      case .invalidPage:
        return "Invalid page: Pages start at 1 and max at 500. They are expected to be an integer."
      case .invalidDateFormat:
        return "Invalid date: Format needs to be YYYY-MM-DD."
      case .requestTimedOut:
        return "Your request to the backend server timed out. Try again."
      case .requestCountOverLimit:
        return "Your request count (#) is over the allowed limit of (40)."
      case .usernameAndPasswordRequired:
        return "You must provide a username and password."
      case .tooManyAppendObjects:
        return "Too many append to response objects: The maximum number of remote calls is 20."
      case .invalidTimezone:
        return "Invalid timezone: Please consult the documentation for a valid timezone."
      case .confirmActionRequired:
        return "You must confirm this action: Please provide a confirm=true parameter."
      case .invalidUsernameOrPassword:
        return "Invalid username and/or password: You did not provide a valid login."
      case .accountDisabled:
        return "Account disabled: Your account is no longer active. Contact TMDB if this is an error."
      case .emailNotVerified:
        return "Email not verified: Your email address has not been verified."
      case .invalidRequestToken:
        return "Invalid request token: The request token is either expired or invalid."
      case .resourceNotFound:
        return "The resource you requested could not be found."
      case .invalidToken:
        return "Invalid token."
      case .tokenWithoutWritePermission:
        return "This token hasn't been granted write permission by the user."
      case .sessionNotFound:
        return "The requested session could not be found."
      case .noEditPermission:
        return "You don't have permission to edit this resource."
      case .resourceIsPrivate:
        return "This resource is private."
      case .nothingToUpdate:
        return "Nothing to update."
      case .tokenNotApproved:
        return "This request token hasn't been approved by the user."
      case .requestMethodNotSupported:
        return "This request method is not supported for this resource."
      case .backendConnectionFailed:
        return "Couldn't connect to the backend server."
      case .invalidID:
        return "The ID is invalid."
      case .userSuspended:
        return "This user has been suspended."
      case .apiUnderMaintenance:
        return "The API is undergoing maintenance. Try again later."
      case .invalidInput:
        return "The input is not valid."
    }
  }
}
