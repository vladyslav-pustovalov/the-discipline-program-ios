//
//  AddTrainingViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 06/07/2025.
//

import Foundation

@Observable
class AddTrainingViewModel {
    var dayTraining: DayTrainig
    
    var isDayTrainingEmpty: Bool {
        dayTraining.blocks.isEmpty
    }
    
    init(trainingNumber: Int) {
        self.dayTraining = DayTrainig(
            trainingNumber: trainingNumber,
            blocks: [])
    }
    
    func deleteBlock(at offsets: IndexSet) {
        dayTraining.blocks.remove(atOffsets: offsets)
    }
}
