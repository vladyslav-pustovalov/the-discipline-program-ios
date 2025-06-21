//
//  UserView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct UserView: View {
    var user: User?
    
    var body: some View {
        if let user {
            VStack {
                List {
                    Text("Email: \(user.login)")
                    Text("First name: \(user.firstName ?? "")")
                    Text("Last name: \(user.lastName ?? "")")
                    Text("Level: \(user.trainingLevel?.name ?? "")")
                    Text("Birthday: \(Constants.Formatter.dateFormatter.string(from: user.dateOfBirth ?? Date.now))")
                    Text("Phone: \(user.phoneNumber ?? "")")
                }
            }
        } else {
            ContentUnavailableView {
                Text("Something went wrong with loading user's data")
            }
        }
    }
}

#Preview {
    var user: User? = User.mock
    return UserView(user: user)
}
