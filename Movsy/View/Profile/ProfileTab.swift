//
//  ProfileTab.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import SwiftUI

struct ProfileTab: View {
  @Environment(\.editMode) var editMode
  @Environment(AuthenticationViewModel.self) var authVm
  @Environment(MovsyGoRepositoryImpl.self) var movsyRepository
  @Environment(FiltersRepositoryImpl.self) var filtersRepository
  @Environment(FriendsViewModel.self) var friendsVm

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
            movsyRepository: movsyRepository,
            filtersRepository: filtersRepository,
            friendsVm: friendsVm
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
      .refreshable { Task { await self.friendsVm.onRefresh() } }
      .padding(.horizontal)
      .alert(isError ? "Error" : "Success", isPresented: $showAlert, presenting: operationError) { operationError in
        Button("Cancel", role: .cancel) {}
        Button("Ok") {
          if operationError.code == 17014 {
            isReAuthenticating = true
          }
        }
      } message: { operationError in
        Text(alertMessage)
      }
      .sheet(isPresented: $isReAuthenticating) {
        LoginView(
          title: "Authenticate again", isReAuthentication: true, authVm: authVm, authSheetView: .constant(.LOGIN))
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
        authVm.currentUser = nil
      case .failure(let error):
        isError = true
        showAlert = true
        if let error = error as NSError? {
          operationError = error
          alertMessage = "Error deleting account: \(processError(for: error))"
        }
      }
    }
  }

  private func processError(for error: NSError) -> LocalizedStringResource {
    switch error.code {
    case 17014:
      "This operation is sensitive and requires recent authentication. Log in again before retrying this request."
    default: "\(error.localizedDescription)"
    }
  }
}

#Preview {
  @Previewable @State var movsyRepository = MovsyGoRepositoryImpl(
    datasource: JsonMovsyDatasource(client: TMDBJsonClient())
  )
  @Previewable @State var friendsViewModel = FriendsViewModel(
    movsyRepository: MovsyGoRepositoryImpl(
      datasource: JsonMovsyDatasource(
        client: TMDBJsonClient()
      )
    )
  )
  @Previewable @State var filtersRepository = FiltersRepositoryImpl(filtersDatasource: JsonFiltersDatasource())
  @Previewable @State var authenticationViewModel = AuthenticationViewModel(
    authenticationRepository: AuthenticationFirebaseRepository(
      dataSource: AuthenticationFirebaseDataSource()
    ),
        movsyRepository: MovsyGoRepositoryImpl(
      datasource: JsonMovsyDatasource(
        client: TMDBJsonClient()
      )
    )
  )

  NavigationStack {
    ProfileTab()
      .environment(authenticationViewModel)
      .environment(movsyRepository)
      .environment(filtersRepository)
      .environment(friendsViewModel)
      .task {
        authenticationViewModel.currentUser = .default
      }
  }
}
