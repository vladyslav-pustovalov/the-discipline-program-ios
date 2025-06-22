//
//  DailyProgram.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

struct DailyProgram: Codable {
    var dayTrainings: [DayTrainig]
}

extension DailyProgram {
    static var mock: DailyProgram {
        DailyProgram(dayTrainings: [DayTrainig.mock])
    }
}
