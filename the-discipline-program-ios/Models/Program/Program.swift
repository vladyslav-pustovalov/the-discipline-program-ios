//
//  Program.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

import Foundation

struct Program: Codable, Equatable {
    var id: Int
    var scheduledDate: Date
    var trainingLevel: TrainingLevel?
    var isRestDay: Bool
    var dailyProgram: DailyProgram?
}

extension Program {
    static var mock: Program {
        let program: Program = Bundle.main.decode("program-example.json")
        return program
    }
}
