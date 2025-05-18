//
//  Team.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import Foundation
import SwiftData

@Model
final class Team: Codable {
    
    @Attribute(.unique) private(set) var id: Int
    private(set) var name: String

    // MARK: - Initializer
    init(
        id: Int,
        name: String
    ) {
        self.id = id
        self.name = name
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)

        self.init(id: id, name: name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

extension Team {
    static var mock: Team {
        Team(
            id: 1,
            name: "TestTeam"
        )
    }
}
