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
        VStack {
            LoadingView(state: userViewModel.state) { user in
                VStack {
                    List {
                        Text("Email: \(user.username)")
                        Text("First name: \(user.firstName ?? "")")
                        Text("Last name: \(user.lastName ?? "")")
                        Text("Level: \(user.trainingLevel != nil ? user.trainingLevel!.name : "")")
                        UserBirthdayView(date: user.dateOfBirth)
                        Text("Phone: \(user.phoneNumber ?? "")")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink() {
                            ChangePasswordView()
                        } label: {
                            Text("Change Password")
                                .padding()
                                .padding(.bottom, 20)
                        }
                    }
                    
                    if authViewModel.userRole == UserRole(id: 2, name: "ADMIN") {
                        ToolbarItem(placement: .automatic) {
                            NavigationLink() {
                                ChangeTrainingLevelView() {
                                    userViewModel.reloadUser()
                                }
                            } label: {
                                Text("Change User Role")
                            }
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
                .onAppear {
                    if error.code == 403 {
                        authViewModel.signOut()
                    }
                }
            }
        }
        .navigationTitle("Profile")
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
        }
        .onAppear {
            if case .idle = userViewModel.state {
                userViewModel.loadUser()
            }
        }
    }
}

private struct UserBirthdayView: View {
    var date: Date?
    
    var body: some View {
        if let date {
            Text("Birthday: \(Constants.Formatter.dateFormatter.string(from: date))")
        } else {
            Text("Birthday: ")
        }
    }
}

#Preview {
    UserView()
        .environment(AuthViewModel())
}
