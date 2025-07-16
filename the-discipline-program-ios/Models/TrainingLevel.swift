//
//  TrainingLevel.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

struct TrainingLevel: Codable, Equatable, Identifiable, Hashable {
    var id: Int
    var name: String
}

extension TrainingLevel {
    static var mock = TrainingLevel(id: 1, name: "Scaled")
}
