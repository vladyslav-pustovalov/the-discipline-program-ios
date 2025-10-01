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
    static var scaled = TrainingLevel(id: 1, name: "Scaled")
    static var pro = TrainingLevel(id: 2, name: "Pro")
    static var advanced = TrainingLevel(id: 3, name: "Advanced")
}
