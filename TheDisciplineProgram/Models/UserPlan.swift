//
//  UserPlan.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 30/09/2025.
//

import Foundation

struct UserPlan: Codable, Identifiable, Hashable, Equatable {
    var id: Int
    var name: String
}

enum UserPlanType {
    case general
    case individual
}

extension UserPlan {
    static var general = UserPlan(id: 1, name: "General")
    static var individual = UserPlan(id: 2, name: "Individual")
}
