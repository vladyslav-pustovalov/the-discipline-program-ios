//
//  GeneralProgramView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

import SwiftUI

struct ProgramView: View {
    var program: Program?
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd.MM.yy"
        return formatter
    }
    
    var body: some View {
        if let program {
            VStack {
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
            }
            .navigationTitle("\(formatter.string(from: program.scheduledDate))")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Previous day") {}
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Next day") {}
                }
            }
        } else {
            Text("The program is Nil")
        }
    }
}

#Preview {
    ProgramView(program: Program.mock)
}
