//
//  EditUserView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 21/06/2025.
//

import SwiftUI

struct EditUserView: View {
    @Environment(\.dismiss) var dismiss
    @State private var editUserViewModel: EditUserViewModel
    
    var onSave: (User) -> Void
    
    init(user: User, onSave: @escaping (User) -> Void) {
        self._editUserViewModel = State(initialValue: EditUserViewModel(user: user))
        self.onSave = onSave
    }
    
    var body: some View {
        Form {
            Section(header: Text("User Details")) {
                TextField("First Name", text: $editUserViewModel.firstName)
                TextField("Last Name", text: $editUserViewModel.lastName)
                TextField("Phone Number", text: $editUserViewModel.phoneNumber)
                DatePicker("Date of Birth", selection: $editUserViewModel.dateOfBirth, displayedComponents: .date)
            }
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if case .loading = editUserViewModel.state {
                    ProgressView()
                } else {
                    Button("Save", action: trySaveUpdatedUser)
                }
            }
        }
        .alert("Something went wrong during user update", isPresented: $editUserViewModel.showingAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            if case .error(let error) = editUserViewModel.state {
                Text("Status code: \(error.code), \(error.description)")
            }
        }
    }
    
    private func trySaveUpdatedUser() {
        Task {
            await editUserViewModel.saveUpdatedUser()
            if case .loaded(let user) = editUserViewModel.state {
                onSave(user)
                dismiss()
            }
        }
    }
}

#Preview {
    EditUserView(user: User.mock) { _ in }
}
