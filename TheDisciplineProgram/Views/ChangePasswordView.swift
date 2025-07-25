//
//  ChangePasswordView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 30/06/2025.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthViewModel.self) var authViewModel
    @State var changePasswordViewModel: ChangePasswordViewModel
    
    init() {
        _changePasswordViewModel = State(initialValue: ChangePasswordViewModel())
    }
    
    var body: some View {
        Form {
            Section("Change Password") {
                SecureField("Old Password", text: $changePasswordViewModel.oldPassword)
                SecureField("New Password", text: $changePasswordViewModel.newPassword)
                SecureField("Confirm New Password", text: $changePasswordViewModel.confirmNewPassword)
            }
        }
        .safeAreaInset(edge: .bottom) {
            VStack {
                if changePasswordViewModel.oldPassword.isEmpty || changePasswordViewModel.newPassword.isEmpty {
                    
                } else if changePasswordViewModel.isOldAndNewPasswordsTheSame {
                    Text("New password should be differen")
                        .foregroundStyle(.secondary)
                        .foregroundStyle(.red)
                } else if !changePasswordViewModel.isNewPasswordConfirmed {
                    Text("New password is not confirmed")
                        .foregroundStyle(.secondary)
                        .foregroundStyle(.red)
                } else {
                    Text("All is good")
                        .foregroundStyle(.secondary)
                        .foregroundStyle(.green)
                }
            }
            .padding()
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: { dismiss() })
            }
            ToolbarItem(placement: .confirmationAction) {
                if case .loading = changePasswordViewModel.state {
                    ProgressView()
                } else {
                    Button("Save", action: tryChangePassword)
                        .disabled(!changePasswordViewModel.isNewPasswordConfirmed || changePasswordViewModel.isOldAndNewPasswordsTheSame)
                }
            }
        }
        .alert("Something went wrong during password change", isPresented: $changePasswordViewModel.showingAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            if case .error(let error) = changePasswordViewModel.state {
                Text("Status code: \(error.code), \(error.description)")
            }
        }
    }
    
    private func tryChangePassword() {
        Task {
            await changePasswordViewModel.saveNewPassword()
            if case .loaded(_) = changePasswordViewModel.state {
                authViewModel.signOut()
                dismiss()
            }
        }
    }
}

#Preview {
    ChangePasswordView()
        .environment(AuthViewModel())
}
