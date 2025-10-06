//
//  ChangeUserRoleView.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 17/08/2025.
//

import SwiftUI

struct ChangePrivateUserDataView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthViewModel.self) var authViewModel
    @State var changePrivateUserDataViewModel: ChangePrivateUserDataViewModel
    
    var onSave: () -> Void
    
    init(onSave: @escaping () -> Void) {
        _changePrivateUserDataViewModel = State(initialValue: ChangePrivateUserDataViewModel())
        self.onSave = onSave
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Training Level") {
                    Picker("Training Level", selection: $changePrivateUserDataViewModel.trainingLevel) {
                        ForEach(changePrivateUserDataViewModel.trainingLevels) { level in
                            Text("\(level.name)").tag(level)
                        }
                    }
                    .pickerStyle(.palette)
                }
                
                Section("User Plan") {
                    Picker("User Plan", selection: $changePrivateUserDataViewModel.userPlan) {
                        ForEach(changePrivateUserDataViewModel.userPlans) { plan in
                            Text("\(plan.name)").tag(plan)
                        }
                    }
                    .pickerStyle(.palette)
                }
            }
        }
        .navigationTitle("Change User Data")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if case .loading = changePrivateUserDataViewModel.state {
                    ProgressView()
                } else {
                    Button("Save", action: tryChangeUserData)
                }
            }
        }
        .alert(changePrivateUserDataViewModel.alertMessage, isPresented: $changePrivateUserDataViewModel.showingAlert) {
            Button("Ok", role: .cancel) {
                changePrivateUserDataViewModel.alertMessage = ""
            }
        } message: {
            if case .error(let error) = changePrivateUserDataViewModel.state {
                Text("Status code: \(error.code), \(error.description)")
            }
        }
        .onAppear {
            Task {
                await changePrivateUserDataViewModel.loadTrainingLevels()
                await changePrivateUserDataViewModel.loadUserPlans()
            }
        }
    }
    
    private func tryChangeUserData() {
        Task {
            await changePrivateUserDataViewModel.changeTrainingLevel()
            await changePrivateUserDataViewModel.changeUserPlan()
            
            if case .loaded(_) = changePrivateUserDataViewModel.state {
                onSave()
                dismiss()
            }
        }
    }
}

#Preview {
    ChangePrivateUserDataView() {  }
        .environment(AuthViewModel())
}
