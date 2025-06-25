//
//  EditUserView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 21/06/2025.
//

import SwiftUI

struct EditUserView: View {
    @State private var editUserViewModel: EditUserViewModel
    
    var onSave: (User) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    init(user: User, onSave: @escaping (User) -> Void) {
        self._editUserViewModel = State(initialValue: EditUserViewModel(user: user))
        self.onSave = onSave
    }
    
    var body: some View {
        Form {
            Section(header: Text("User Details")) {
                TextField("Login", text: $editUserViewModel.login)
            }
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: { dismiss() })
            }
            ToolbarItem(placement: .confirmationAction) {
                if editUserViewModel.isSaving {
                    ProgressView()
                } else {
                    Button("Save", action: handleSave)
                }
            }
        }
    }
    
    private func handleSave() {
        Task {
            do {
                let updatedUser = try await editUserViewModel.save()
                onSave(updatedUser)
                dismiss()
            } catch {
                print("Failed to save user")
            }
        }
    }
}

//#Preview {
//    @Previewable @State var user: User = User.mock
//    return EditUserView(user: user)
//}
