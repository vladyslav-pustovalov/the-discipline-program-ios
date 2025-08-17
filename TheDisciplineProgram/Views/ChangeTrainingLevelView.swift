//
//  ChangeUserRoleView.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 17/08/2025.
//

import SwiftUI

struct ChangeTrainingLevelView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(AuthViewModel.self) var authViewModel
    @State var changeTrainingLevelViewModel: ChangeTrainingLevelViewModel
    
    var onSave: () -> Void
    
    init(onSave: @escaping () -> Void) {
        _changeTrainingLevelViewModel = State(initialValue: ChangeTrainingLevelViewModel())
        self.onSave = onSave
    }
    
    var body: some View {
        VStack {
            Form {
                Picker("Training Level", selection: $changeTrainingLevelViewModel.trainingLevel) {
                    ForEach(changeTrainingLevelViewModel.trainingLevels) { level in
                        Text("\(level.name)").tag(level)
                    }
                }
                .pickerStyle(.palette)
            }
        }
        .navigationTitle("Chagne User Role")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if case .loading = changeTrainingLevelViewModel.state {
                    ProgressView()
                } else {
                    Button("Save", action: tryChangeTrainingLevel)
                }
            }
        }
        .alert(changeTrainingLevelViewModel.alertMessage, isPresented: $changeTrainingLevelViewModel.showingAlert) {
            Button("Ok", role: .cancel) {
                changeTrainingLevelViewModel.alertMessage = ""
            }
        } message: {
            if case .error(let error) = changeTrainingLevelViewModel.state {
                Text("Status code: \(error.code), \(error.description)")
            }
        }
        .onAppear {
            Task {
                await changeTrainingLevelViewModel.loadTrainingLevels()
            }
        }
    }
    
    private func tryChangeTrainingLevel() {
        Task {
            await changeTrainingLevelViewModel.changeTrainingLevel()
            if case .loaded(_) = changeTrainingLevelViewModel.state {
                onSave()
                dismiss()
            }
        }
    }
}

#Preview {
    ChangeTrainingLevelView() {  }
        .environment(AuthViewModel())
}
