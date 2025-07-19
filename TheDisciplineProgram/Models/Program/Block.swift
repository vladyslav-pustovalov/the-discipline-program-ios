//
//  Block.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

struct Block: Codable, Equatable {
    var name: String
    var exercises: [String]
}

extension Block {
    static var mock: Block {
        Block(name: "weightlifting", exercises: ["First", "Second"])
    }
}
