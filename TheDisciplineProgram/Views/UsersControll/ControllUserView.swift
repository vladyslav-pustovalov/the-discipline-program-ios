//
//  ControllUserView.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 02/10/2025.
//

import SwiftUI

struct ControllUserView: View {
    @Environment(\.dismiss) var dismiss
    @State var controllUserViewModel: ControllUserViewModel
    var onSave: (User) -> Void
    
    init(user: User, onSave: @escaping (User) -> Void) {
        self._controllUserViewModel = State(initialValue: ControllUserViewModel(user: user))
        self.onSave = onSave
    }
    
    var body: some View {
        Form {
            Text(controllUserViewModel.user.username)
            
            Toggle("Is Enabled", isOn: $controllUserViewModel.user.isEnabled)
            
            Picker("Training Level", selection: $controllUserViewModel.user.trainingLevel) {
                ForEach(controllUserViewModel.trainingLevels) { level in
                    Text("\(level.name)").tag(Optional(level))
                }
            }
            
            Picker("User Plans", selection: $controllUserViewModel.user.userPlan) {
                ForEach(controllUserViewModel.userPlans) { plan in
                    Text("\(plan.name)").tag(Optional(plan))
                }
            }
        }
        .navigationTitle("Edit User")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if case .loading = controllUserViewModel.state {
                    ProgressView()
                } else {
                    Button("Save", action: trySaveUpdatedUser)
                }
            }
        }
        .alert("Something went wrong during user update", isPresented: $controllUserViewModel.showingAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            if case .error(let error) = controllUserViewModel.state {
                Text("Status code: \(error.code), \(error.description)")
            }
        }
        .onAppear {
            Task {
                await controllUserViewModel.loadUserPlans()
                await controllUserViewModel.loadTrainingLevels()
            }
        }
    }
    
    private func trySaveUpdatedUser() {
        Task {
            await controllUserViewModel.saveUpdatedUser()
            if case .loaded(let user) = controllUserViewModel.state {
                onSave(user)
                dismiss()
            }
        }
    }
}

#Preview {
    ControllUserView(user: User.mock) { _ in }
}
