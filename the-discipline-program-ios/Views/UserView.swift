//
//  UserView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct UserView: View {
    @Environment(AuthViewModel.self) var authViewModel
    @State var userViewModel = UserViewModel()
    
    var body: some View {
        VStack {
            LoadingView(state: userViewModel.state) { user in
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
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .destructive, action: authViewModel.signOut) {
                            Text("Sign Out")
                                .padding(5)
                                .background(.gray.opacity(0.3))
                                .foregroundStyle(.red)
                                .clipShape(.buttonBorder)
                        }
                        
                    }
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink("Edit") {
                            EditUserView(user: user) { updatedUser in
                                userViewModel.updateUser(updatedUser)
                            }
                        }
                        
                    }
                }
            } errorContent: { error in
                ContentUnavailableView {
                    Text("\(error.code)")
                    Text("\(error.localizedDescription)")
                }
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            if case .idle = userViewModel.state {
                userViewModel.loadUser()
            }
        }
    }
}

#Preview {
    UserView()
        .environment(AuthViewModel())
}
