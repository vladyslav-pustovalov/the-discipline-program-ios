//
//  User.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import Foundation

struct User: Codable, Equatable {
    var id: Int
    var username: String
    var userRole: UserRole
    
    var trainingLevel: TrainingLevel?
    
    var firstName: String?
    var lastName: String?
    var dateOfBirth: Date?
    var team: Team?
    var phoneNumber: String?
}

extension User {
    static var mock: User {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return User(
            id: 1,
            username: "user@email.com",
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
