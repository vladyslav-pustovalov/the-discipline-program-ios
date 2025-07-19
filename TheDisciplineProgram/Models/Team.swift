//
//  Team.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import Foundation

struct Team: Codable, Equatable {
    private(set) var id: Int
    private(set) var name: String
}

extension Team {
    static var mock: Team {
        Team(
            id: 1,
            name: "TestTeam"
        )
    }
}
