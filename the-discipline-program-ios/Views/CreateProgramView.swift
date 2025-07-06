//
//  CreateProgramView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 06/07/2025.
//

import SwiftUI

struct CreateProgramView: View {
    @State private var createProgramViewModel: CreateProgramViewModel
    
    init() {
        self._createProgramViewModel = State(initialValue: CreateProgramViewModel())
    }
    
    var body: some View {
        Form {
            Section {
                DatePicker("Scheduled date", selection: $createProgramViewModel.scheduledDate, displayedComponents: .date)
                
                ForEach(createProgramViewModel.dailyProgram.dayTrainings.indices, id: \.self) { index in
                    NavigationLink("Training number: \(createProgramViewModel.dailyProgram.dayTrainings[index].trainingNumber)") {
                        AddTrainingView(
                            dayTraining: createProgramViewModel.dailyProgram.dayTrainings[index],
                            trainingNumber: createProgramViewModel.dailyProgram.dayTrainings[index].trainingNumber
                        ) { dayTraining in
                            createProgramViewModel.dailyProgram.dayTrainings[index] = dayTraining
                        }
                    }
                }
                
                NavigationLink("Add Day trainig") {
                    AddTrainingView(trainingNumber: (createProgramViewModel.dailyProgram.dayTrainings.last?.trainingNumber ?? 0) + 1) { dayTraining in
                        createProgramViewModel.dailyProgram.dayTrainings.append(dayTraining)
                    }
                }
            }
        }
        .navigationTitle("Create Program")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if case .loading = createProgramViewModel.state {
                    ProgressView()
                } else {
                    Button("Save", action: trySaveNewProgram)
                }
            }
        }
        .alert("Something went wrong during creating a program", isPresented: $createProgramViewModel.showingAlert) {
            Button("Ok", role: .cancel) {}
        } message: {
            if case .error(let error) = createProgramViewModel.state {
                Text("Status code: \(error.code), \(error.description)")
            }
        }
    }
    
    private func trySaveNewProgram() {
        Task {
            await createProgramViewModel.saveNewProgram()
            
            if case .loaded(let program) = createProgramViewModel.state {
                
            }
        }
    }
}
