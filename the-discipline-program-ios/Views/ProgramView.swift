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
                                ForEach(training.blocks, id: \.name) { block in
                                    Section {
                                        ForEach(block.exercises, id: \.self) { exercise in
                                            Text(exercise)
                                        }
                                    } header: {
                                        Text("\(block.name)")
                                            .font(.headline)
                                            .foregroundStyle(.black)
                                    }
                                }
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
