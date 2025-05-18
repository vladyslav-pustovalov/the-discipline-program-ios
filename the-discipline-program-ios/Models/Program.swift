//
//  Program.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import Foundation
import SwiftData

@Model
final class Program: Codable {
    
    @Attribute(.unique) private(set) var id: Int
    private(set) var startDate: Date
    private(set) var endDate: Date
    private(set) var level: Level
    private(set) var program: String

    // MARK: - Initializer
    init(
        id: Int,
        startDate: Date,
        endDate: Date,
        level: Level,
        program: String
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.level = level
        self.program = program
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id
        case startDate
        case endDate
        case level
        case program
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                                              
        let id = try container.decode(Int.self, forKey: .id)
        let startDate = try container.decode(Date.self, forKey: .startDate)
        let endDate = try container.decode(Date.self, forKey: .endDate)
        let level = try container.decode(Level.self, forKey: .level)
        let program = try container.decode(String.self, forKey: .program)

        self.init(id: id, startDate: startDate, endDate: endDate, level: level, program: program)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(level, forKey: .level)
        try container.encode(program, forKey: .program)
    }
}

extension Program {
    static var mock: Program {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return Program(
            id: 1,
            startDate: formatter.date(from: "2000-1-10")!,
            endDate: formatter.date(from: "2000-2-20")!,
            level: .ameteur,
            program: "Test Program"
        )
    }
}
