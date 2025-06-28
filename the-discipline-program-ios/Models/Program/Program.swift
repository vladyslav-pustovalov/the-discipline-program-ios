//
//  Program.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

import Foundation

struct Program: Codable, Equatable {
    private(set) var id: Int
    private(set) var scheduledDate: Date
    private(set) var isRestDay: Bool
    private(set) var dailyProgram: DailyProgram?
}

extension Program {
    static var mock: Program {
        let program: Program = Bundle.main.decode("program-example.json")
        return program
    }
}
