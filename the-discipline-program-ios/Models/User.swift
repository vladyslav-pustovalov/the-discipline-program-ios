//
//  User.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import Foundation

struct User: Codable {
    private(set) var id: Int?
    private(set) var login: String
    private(set) var password: String
    private(set) var userRole: UserRole
    
    private(set) var trainingLevel: TrainingLevel?
    
    var firstName: String?
    private(set) var lastName: String?
    private(set) var dateOfBirth: Date?
    private(set) var team: Team?
    private(set) var phoneNumber: String?
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
