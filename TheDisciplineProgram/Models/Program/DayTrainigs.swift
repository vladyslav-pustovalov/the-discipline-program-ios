//
//  DayTrainigs.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

struct DayTrainig: Codable, Equatable {
    var trainingNumber: Int
    var blocks: [Block]
}

extension DayTrainig {
    static var mock: DayTrainig {
        DayTrainig(trainingNumber: 1, blocks: [Block.mock])
    }
}
