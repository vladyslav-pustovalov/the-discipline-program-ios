//
//  User.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import Foundation

struct User: Codable, Equatable, Hashable, Identifiable {
    var id: Int
    var username: String
    var userRole: UserRole
    
    var trainingLevel: TrainingLevel?
    var userPlan: UserPlan?
    
    var firstName: String?
    var lastName: String?
    var dateOfBirth: Date?
    var team: Team?
    var phoneNumber: String?
}

extension User {
    var visibleName: String {
        if let firstName, let lastName {
            return "\(firstName) \(lastName)"
        }
        return username
    }
}

extension User {
    static var mock: User {
        User(
            id: 1,
            username: "user@email.com",
            userRole: UserRole.roleUser,
            trainingLevel: TrainingLevel.pro,
            userPlan: UserPlan.general,
            firstName: "TestF",
            lastName: "TestL",
            dateOfBirth: Constants.Formatter.dateFormatter.date(from: "2000-10-20")!,
            team: Team.mock,
            phoneNumber: "778877"
        )
    }
}
