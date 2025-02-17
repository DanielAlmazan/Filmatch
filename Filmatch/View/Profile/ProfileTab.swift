//
//  ProfileTab.swift
//  Filmatch
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import SwiftUI

struct ProfileTab: View {
  @Environment(\.editMode) var editMode
  @Environment(AuthenticationViewModel.self) var authVm
  @Environment(FilmatchGoRepositoryImpl.self) var filmatchRepository
  @Environment(FiltersRepositoryImpl.self) var filtersRepository
  
  @State private var showAlert = false
  @State private var alertMessage: LocalizedStringResource = ""
  @State private var isError = false
  @State private var operationError: NSError?
  
  @State private var isReAuthenticating = false

  var body: some View {
    if let user = authVm.currentUser {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          ProfileSummary(
            user: user,
            filmatchRepository: filmatchRepository,
            filtersRepository: filtersRepository
          )
            .frame(maxWidth: .infinity)
          
          Group {
            Button("Log out") {
              authVm.logOut()
            }
            
            Button("Delete Account") {
              deleteAccount()
            }
            .foregroundStyle(.red)
          }
          .buttonStyle(.bordered)
          .frame(maxWidth: .infinity, alignment: .center)
        }
      }
      .padding()
      .alert(isError ? "Error" : "Success", isPresented: $showAlert, presenting: operationError) { operationError in
        Button("Cancel", role: .cancel) { }
        Button("Ok") {
          if operationError.code == 17014 {
            isReAuthenticating = true
          }
        }
      } message: { operationError in
        Text(alertMessage)
      }
      .sheet(isPresented: $isReAuthenticating) {
        LoginView(title: "Authenticate again", isReAuthentication: true, authVm: authVm, authSheetView: .constant(.LOGIN))
      }
    } else {
      VStack {
        Text("No user logged in.")
      }
    }
  }
  
  private func deleteAccount() {
//    authVm.deleteAccount { result in
//      
//      showAlert = true
//    }
    Task {
      let result = await authVm.deleteAccount()
      switch result {
      case .success(_):
        isError = false
      case .failure(let error):
        if let error = error as NSError? {
          operationError = error
          alertMessage = "Error deleting account: \(processError(for: error))"
          isError = true
        }
      }
    }
  }
  
  private func processError(for error: NSError) -> LocalizedStringResource {
    switch error.code {
      case 17014: "This operation is sensitive and requires recent authentication. Log in again before retrying this request."
      default: "\(error.localizedDescription)"
    }
  }
}

#Preview {
  @Previewable @State var filmatchRepository = FilmatchGoRepositoryImpl(
    datasource: FilmatchGoDatasourceImpl(
      client: FilmatchHttpClient(
        urlBase: AppConstants.filmatchBaseUrl)
    )
  )
  @Previewable let filtersRepository = FiltersRepositoryImpl(filtersDatasource: JsonFiltersDatasource())
  @Previewable @State var vm = AuthenticationViewModel(
    authenticationRepository: AuthenticationFirebaseRepository(
      dataSource: AuthenticationFirebaseDataSource()
    ),
    filmatchRepository: FilmatchGoRepositoryImpl(
      datasource: FilmatchGoDatasourceImpl(
        client: FilmatchHttpClient(
          urlBase: AppConstants.filmatchBaseUrl)
      )
    )
  )
  
  ProfileTab()
    .environment(vm)
    .environment(filmatchRepository)
    .environment(filtersRepository)
}
