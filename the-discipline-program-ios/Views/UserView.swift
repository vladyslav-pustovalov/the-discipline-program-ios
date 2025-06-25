//
//  UserView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct UserView: View {
    @Environment(AuthViewModel.self) var authViewModel
    @State var userViewModel: UserViewModel
    
    init() {
        _userViewModel = State(wrappedValue: UserViewModel())
    }
    
    var body: some View {
        if let user = userViewModel.user {
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(role: .destructive, action: authViewModel.signOut) {
                        Text("Sign Out")
                            .padding(5)
                            .background(.gray.opacity(0.3))
                            .foregroundStyle(.red)
                            .clipShape(.buttonBorder)
                    }
                        
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        EditUserView(user: $userViewModel.user)
                    }
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
    UserView()
        .environment(AuthViewModel())
}
