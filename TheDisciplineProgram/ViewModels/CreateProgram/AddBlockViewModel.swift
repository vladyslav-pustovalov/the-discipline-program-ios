//
//  AddBlockViewModel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 06/07/2025.
//

import Foundation

@Observable
class AddBlockViewModel {
    var block = Block(name: "", exercises: [])
    var newExercise = ""
    
    var isBlockNameEmpty: Bool {
        block.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func addExercise() {
        let trimmed = newExercise.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        block.exercises.append(trimmed)
        newExercise = ""
    }

    func deleteExercise(at offsets: IndexSet) {
        block.exercises.remove(atOffsets: offsets)
    }
}
