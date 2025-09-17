//
//  DayTrainigs.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

struct DayTrainig: Codable, Equatable, Hashable, Identifiable {
    var trainingNumber: Int
    var blocks: [Block]
    var id: Int {
        trainingNumber
    }
}

extension DayTrainig {
    static var mock: DayTrainig {
        DayTrainig(trainingNumber: 1, blocks: [Block.mock])
    }
}
