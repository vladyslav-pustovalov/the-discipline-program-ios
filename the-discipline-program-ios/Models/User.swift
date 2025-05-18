//
//  User.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import Foundation
import SwiftData

@Model
final class User: Codable {
    
    @Attribute(.unique) private(set) var id: Int?
    private(set) var email: String
    private(set) var password: String
    private(set) var role: Role?
    private(set) var level: Level?
    private(set) var firstName: String?
    private(set) var lastName: String?
    private(set) var dateOfBirth: Date?
    private(set) var team: Team?
    private(set) var phoneNumber: String?

    // MARK: - Initializer
    init(
        id: Int? = nil,
         email: String,
         password: String,
         role: Role? = nil,
         level: Level? = nil,
         firstName: String? = nil,
         lastName: String? = nil,
         dateOfBirth: Date? = nil,
         team: Team? = nil,
         phoneNumber: String? = nil
    ) {
        self.id = id
        self.email = email
        self.password = password
        self.role = role
        self.level = level
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.team = team
        self.phoneNumber = phoneNumber
    }

    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case password
        case role
        case level
        case firstName
        case lastName
        case dateOfBirth
        case team
        case phoneNumber
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decodeIfPresent(Int.self, forKey: .id)
        let email = try container.decode(String.self, forKey: .email)
        let password = try container.decode(String.self, forKey: .password)
        let role = try container.decodeIfPresent(Role.self, forKey: .role)
        let level = try container.decodeIfPresent(Level.self, forKey: .level)
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        let dateOfBirth = try container.decodeIfPresent(Date.self, forKey: .dateOfBirth)
        let team = try container.decodeIfPresent(Team.self, forKey: .team)
        let phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)

        self.init(id: id, email: email, password: password, role: role, level: level, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, team: team, phoneNumber: phoneNumber)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(id, forKey: .id)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encodeIfPresent(role, forKey: .role)
        try container.encodeIfPresent(level, forKey: .level)
        try container.encodeIfPresent(firstName, forKey: .firstName)
        try container.encodeIfPresent(lastName, forKey: .lastName)
        try container.encodeIfPresent(dateOfBirth, forKey: .dateOfBirth)
        try container.encodeIfPresent(team, forKey: .team)
        try container.encodeIfPresent(phoneNumber, forKey: .phoneNumber)
    }
}

extension User {
    static var mock: User {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return User(
            id: 1,
            email: "user@email.com",
            password: "12345",
            role: .athlete,
            level: .ameteur,
            firstName: "TestF",
            lastName: "TestL",
            dateOfBirth: formatter.date(from: "2000-10-20")!,
            team: Team.mock,
            phoneNumber: "778877"
        )
    }
}
