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
    var isRestDay: Bool
    var dailyProgram: DailyProgram?
    
    init(id: Int, scheduledDate: Date, isRestDay: Bool, dailyProgram: DailyProgram?) {
        self.id = id
        self.scheduledDate = scheduledDate
        self.isRestDay = isRestDay
        self.dailyProgram = dailyProgram ?? nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case scheduledDate
        case isRestDay
        case dailyProgram
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let dateString = try container.decode(String.self, forKey: .scheduledDate)
        let isRestDay = try container.decode(Bool.self, forKey: .isRestDay)
        let dailyProgram = try container.decodeIfPresent(DailyProgram.self, forKey: .dailyProgram)
        
        guard let scheduledDate = Constants.Formatter.dateFormatter.date(from: dateString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .scheduledDate,
                in: container,
                debugDescription: "Invalid date format"
            )
        }
        
        self.init(id: id, scheduledDate: scheduledDate, isRestDay: isRestDay, dailyProgram: dailyProgram)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(scheduledDate, forKey: .scheduledDate)
        try container.encode(isRestDay, forKey: .isRestDay)
        try container.encode(dailyProgram, forKey: .dailyProgram)
    }
}

extension Program {
    static var mock: Program {
        let program: Program = Bundle.main.decode("program-example.json")
        return program
    }
}
