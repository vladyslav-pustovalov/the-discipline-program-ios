//
//  User.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import Foundation

struct User: Codable, Equatable {
    var id: Int
    var login: String
    var password: String
    var userRole: UserRole
    
    var trainingLevel: TrainingLevel?
    
    var firstName: String?
    var lastName: String?
    var dateOfBirth: Date?
    var team: Team?
    var phoneNumber: String?
    
    init(id: Int, login: String, password: String, userRole: UserRole, trainingLevel: TrainingLevel? = nil, firstName: String? = nil, lastName: String? = nil, dateOfBirth: Date? = nil, team: Team? = nil, phoneNumber: String? = nil) {
        self.id = id
        self.login = login
        self.password = password
        self.userRole = userRole
        self.trainingLevel = trainingLevel
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.team = team
        self.phoneNumber = phoneNumber
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case login
        case password
        case userRole
        case trainingLevel
        case firstName
        case lastName
        case dateOfBirth
        case team
        case phoneNumber
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let id = try container.decode(Int.self, forKey: .id)
        let login = try container.decode(String.self, forKey: .login)
        let password = try container.decode(String.self, forKey: .password)
        let userRole = try container.decode(UserRole.self, forKey: .userRole)
        let trainingLevel = try container.decodeIfPresent(TrainingLevel.self, forKey: .trainingLevel)
        let firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        let lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        let dateString = try container.decodeIfPresent(String.self, forKey: .dateOfBirth)
        let team = try container.decodeIfPresent(Team.self, forKey: .team)
        let phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber)
        
        var dateOfBirth: Date?
        if let dateString {
            if let date = Constants.Formatter.dateFormatter.date(from: dateString) {
                dateOfBirth = date
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .dateOfBirth,
                    in: container,
                    debugDescription: "Invalid date format"
                )
            }
        }
        
        self.init(id: id, login: login, password: password, userRole: userRole, trainingLevel: trainingLevel, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, team: team, phoneNumber: phoneNumber)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(login, forKey: .login)
        try container.encode(password, forKey: .password)
        try container.encode(userRole, forKey: .userRole)
        try container.encode(trainingLevel, forKey: .trainingLevel)
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
            login: "user@email.com",
            password: "12345",
            userRole: UserRole.roleUser,
            trainingLevel: TrainingLevel.mock,
            firstName: "TestF",
            lastName: "TestL",
            dateOfBirth: formatter.date(from: "2000-10-20")!,
            team: Team.mock,
            phoneNumber: "778877"
        )
    }
}
