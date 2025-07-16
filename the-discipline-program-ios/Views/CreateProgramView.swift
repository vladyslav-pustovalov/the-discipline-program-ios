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
                    ForEach(createProgramViewModel.trainingLevels) { level in
                        Text("\(level.name)").tag(level)
                    }
                }
                Toggle("Is Rest Day", isOn: $createProgramViewModel.isRestDay)
                
                if createProgramViewModel.isRestDay == false {
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
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            if createProgramViewModel.isRestDay == false {
                NavigationLink(
                    destination: AddTrainingView(
                        trainingNumber: (createProgramViewModel.dailyProgram.dayTrainings.last?.trainingNumber ?? 0) + 1
                    ) { dayTraining in
                        createProgramViewModel.dailyProgram.dayTrainings.append(dayTraining)
                    }
                ) {
                    Text("Add Training to this day >")
                        .fontWeight(.medium)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue.opacity(0.5), lineWidth: 2)
                        )
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
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

#Preview {
    CreateProgramView()
}
