//
//  UserRole.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftData

@Model
final class UserRole: Codable {
    @Attribute(.unique) private(set) var id: Int
    private(set) var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
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

enum UserRoleType {
    case user
    case admin
}

extension UserRole {
    static var roleUser = UserRole(id: 1, name: "USER")
    static var roleAdmin = UserRole(id: 2, name: "ADMIN")
}
