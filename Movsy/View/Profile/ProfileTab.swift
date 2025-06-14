//
//  ProfileTab.swift
//  Movsy
//
//  Created by Daniel Enrique Almazán Sellés on 12/8/24.
//

import SwiftUI

struct ProfileTab: View {
  @Environment(AuthenticationViewModel.self) var authVm
  @Environment(MovsyGoRepositoryImpl.self) var movsyRepository
  @Environment(FiltersRepositoryImpl.self) var filtersRepository
  @Environment(FriendsViewModel.self) var friendsVm

  @State private var isEditing = false
  @State private var newUsername: String = ""
  @State private var showAlert = false
  @State private var alertMessage: LocalizedStringKey = ""
  @State private var isError = false
  @State private var operationError: NSError?

  @State private var isReAuthenticating = false
  @State private var isLoggingOut = false
  @State private var isDeletingAccount = false

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
              isLoggingOut = true
            }
            .alert("Are you sure you want to log out?", isPresented: $isLoggingOut) {
              Button("Cancel", role: .cancel) {}
              Button("Log out", role: .destructive) { logOut() }
            }

            Button("Delete Account") {
              isDeletingAccount = true
            }
            .foregroundStyle(.red)
            .alert("Are you sure you want to delete your account? This action is cannot be undone. All your data will be deleted permanently from our servers.", isPresented: $isDeletingAccount) {
              Button("Cancel", role: .cancel) {}
              Button("Delete", role: .destructive) { deleteAccount() }
            }
          }
          .buttonStyle(.bordered)
          .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal)
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            Task { await self.friendsVm.onRefresh() }
          } label: {
            HStack {
              Image(systemName: "arrow.clockwise.circle.fill")
              Text("Refresh")
            }
          }
        }
      }
      .refreshable { Task { await self.friendsVm.onRefresh() } }
      .alert(alertMessage, isPresented: $showAlert, presenting: operationError) { operationError in
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
      .sheet(isPresented: $isEditing) {
        NavigationStack {
          Form {
            Section("Username") {
              TextField("New username", text: $newUsername)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .submitLabel(.return)
                .onSubmit {
                  onEditUsernameSubmitted()
                }
            }

            Section {
              Button("Save") {
                onEditUsernameSubmitted()
              }
              .disabled(newUsername.trimmingCharacters(in: .whitespaces).isEmpty)

              Button("Cancel", role: .cancel) {
                isEditing = false
              }
            }
          }
          .navigationTitle("Edit Profile")
        }
      }
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Edit") {
            if let currentUsername = authVm.currentUser?.username {
              newUsername = currentUsername
            }
            isEditing = true
          }
        }
      }
    } else {
      VStack {
        Text("No user logged in.")
      }
    }
  }

  private func onEditUsernameSubmitted() {
    Task {
      await updateUsername()
    }
    isEditing = false
  }

  private func updateUsername() async {
    let trimmed = newUsername.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmed.isEmpty else { return }

    let result = await authVm.updateUsername(trimmed)

    if case .failure(let error as NSError) = result {
      isError = true
      showAlert = true
      operationError = error
      alertMessage = "Error updating username: \(processError(for: error))"
    }
  }

  private func logOut() {
    Task { await authVm.logOut() }
  }

  private func deleteAccount() {
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
