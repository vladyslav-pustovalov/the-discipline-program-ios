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
                Picker("Training Level", selection: $createProgramViewModel.trainingLevel) {
                    ForEach(createProgramViewModel.trainigLevels) { level in
                        Text("\(level.name)").tag(level)
                    }
                }
                
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
        .alert(createProgramViewModel.alertMessage, isPresented: $createProgramViewModel.showingAlert) {
            Button("Ok", role: .cancel) {
                createProgramViewModel.alertMessage = ""
            }
        } message: {
            if case .error(let error) = createProgramViewModel.state {
                Text("Status code: \(error.code), \(error.description)")
            }
        }
        .alert(createProgramViewModel.alertMessage, isPresented: $createProgramViewModel.showingAlreadyExistsAlert) {
            Button("Yes") {
                tryUpdateProgram()
                createProgramViewModel.alertMessage = ""
            }
            Button("No", role: .cancel) {
                createProgramViewModel.alertMessage = ""
            }
        }
        .onAppear {
            Task {
                await createProgramViewModel.loadTrainingLevels()
            }
        }
    }
    
    private func trySaveNewProgram() {
        Task {
            await createProgramViewModel.saveNewProgram()
        }
    }
    
    private func tryUpdateProgram() {
        Task {
            await createProgramViewModel.updateProgram()
        }
    }
    
    private func tryLoadTrainingLevels() {
        Task {
            await createProgramViewModel.loadTrainingLevels()
        }
    }
}
