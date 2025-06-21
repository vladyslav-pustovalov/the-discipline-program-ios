//
//  Block.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 09/06/2025.
//

import SwiftData

@Model
final class Block: Codable {
    private(set) var name: String
    private(set) var exercises: [String]
    
    init(name: String, exercises: [String]) {
        self.name = name
        self.exercises = exercises
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case exercises
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let name = try container.decode(String.self, forKey: .name)
        let exercises = try container.decode([String].self, forKey: .exercises)
        
        self.init(name: name, exercises: exercises)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(exercises, forKey: .exercises)
    }
}

extension Block {
    static var mock: Block {
        Block(name: "weightlifting", exercises: ["First", "Second"])
    }
}
