//
//  DailyProgram.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

import SwiftData

@Model
class DailyProgram: Codable {
    var dayTrainings: [DayTrainig]
    
    init(dayTrainings: [DayTrainig]) {
        self.dayTrainings = dayTrainings
    }
    
    enum CodingKeys: String, CodingKey {
        case dayTrainings
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dayTrainings = try container.decode([DayTrainig].self, forKey: .dayTrainings)
        
        self.init(dayTrainings: dayTrainings)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dayTrainings, forKey: .dayTrainings)
    }
}

extension DailyProgram {
    static var mock: DailyProgram {
        DailyProgram(dayTrainings: [DayTrainig.mock])
    }
}
