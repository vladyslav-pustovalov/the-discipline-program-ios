//
//  GeneralProgramView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

import SwiftUI

struct ProgramView: View {
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
                                    Section("Section: \(block.name)") {
                                        ForEach(block.exercises, id: \.self) { exercise in
                                            Text(exercise)
                                        }
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
    }
}

#Preview {
    ProgramView(for: Date.now)
}
