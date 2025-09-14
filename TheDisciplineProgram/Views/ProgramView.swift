//
//  GeneralProgramView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

import SwiftUI

struct ProgramView: View {
    @Environment(AuthViewModel.self) var authViewModel
    @State private var programViewModel: ProgramViewModel
    
    private var programViewDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd.MM.yy"
        return formatter
    }
    
    init(for date: Date) {
        _programViewModel = State(wrappedValue: ProgramViewModel(programDate: date))
    }
    
    var body: some View {
        VStack {            
            LoadingView(state: programViewModel.state) { program in
                if program.isRestDay {
                    Text("Today is the rest day")
                } else {
                    if let dailyProgram = program.dailyProgram {
                        Form {
                            ForEach(dailyProgram.dayTrainings, id: \.trainingNumber) { training in
                                Text("Training number: \(training.trainingNumber)")
                                    .font(.headline)
                                ForEach(training.blocks.indices, id: \.self) { blockIndex in
                                    let block = training.blocks[blockIndex]
                                    
                                    Section {
                                        ForEach(block.exercises.indices, id: \.self) { exerciseIndex in
                                            Text(block.exercises[exerciseIndex])
                                        }
                                    } header: {
                                        Text("\(block.name)")
                                            .font(.headline)
                                            .fontWeight(.heavy)
                                    }
                                    
                                }
                            }
                            
                            if authViewModel.userRole == UserRole.roleAdmin {
                                NavigationLink(
                                    destination: CreateProgramView(program: program, navigationTitle: "Edit Program")
                                ) {
                                    Text("Edit this day's training >")
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
                    } else {
                        fatalError("Somehow Program is nil with isRestDay == false, check the DB and the app code")
                    }
                }
            } errorContent: { error in
                if error.code == 404 {
                    ContentUnavailableView {
                        Text("There is no program for today")
                    }
                } else if error.code == 403 {
                    ContentUnavailableView {
                        Text("Forbidden")
                    }
                    .onAppear {
                        authViewModel.signOut()
                    }
                } else {
                    ContentUnavailableView {
                        Text("Something went wrong with loading today's program")
                    }
                }
            }
        }
        .navigationTitle("\(programViewDateFormatter.string(from: programViewModel.programDate))")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Previous day") {
                    programViewModel.loadPreviousDay()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Next day") {
                    programViewModel.loadNextDay()
                }
            }
            
            ToolbarItem(placement: .automatic) {
                if authViewModel.userRole == UserRole.roleAdmin {
                    NavigationLink(
                        "Edit",
                        destination: CreateProgramView(
                            program: programViewModel.program,
                            navigationTitle: "Edit Program"
                        )
                    )
                }
            }
        }
        .onAppear {
            if case .idle = programViewModel.state {
                programViewModel.loadProgram(for: programViewModel.programDate)
            }
        }
    }
}

#Preview {
    ProgramView(for: Date.now)
        .environment(AuthViewModel())
}
