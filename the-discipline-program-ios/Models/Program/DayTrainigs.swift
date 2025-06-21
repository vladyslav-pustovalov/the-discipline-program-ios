//
//  DayTrainigs.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

import SwiftData

@Model
final class DayTrainig: Codable {
    private(set) var trainingNumber: Int
    private(set) var blocks: [Block]
    
    init(trainingNumber: Int, blocks: [Block]) {
        self.trainingNumber = trainingNumber
        self.blocks = blocks
    }
    
    enum CodingKeys: String, CodingKey {
        case trainingNumber
        case blocks
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let trainingNumber = try container.decode(Int.self, forKey: .trainingNumber)
        let blocks = try container.decode([Block].self, forKey: .blocks)
        
        self.init(trainingNumber: trainingNumber, blocks: blocks)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(trainingNumber, forKey: .trainingNumber)
        try container.encode(blocks, forKey: .blocks)
    }
}

extension DayTrainig {
    static var mock: DayTrainig {
        DayTrainig(trainingNumber: 1, blocks: [Block.mock])
    }
}
