//
//  UsersControllView.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 02/10/2025.
//

import SwiftUI

struct UsersControllView: View {
    @State private var userControllViewModel: UsersControllViewModel
    
    init() {
        self._userControllViewModel = State(initialValue: UsersControllViewModel())
    }
    
    var body: some View {
        VStack {
            LoadingView(state: userControllViewModel.state) { users in
                let filteredUsers = users.filter { user in
                    userControllViewModel.searchText.isEmpty ||
                    user.visibleName
                        .trimmingCharacters(in:.whitespacesAndNewlines)
                        .localizedCaseInsensitiveContains(userControllViewModel.searchText)
                }
                
                List(filteredUsers) { user in
                    NavigationLink("\(user.visibleName)") {
                        ControllUserView(user: user) { user in
                            Task {
                                await userControllViewModel.loadUsers()
                            }
                        }
                    }
                }
                .searchable(text: $userControllViewModel.searchText, prompt: "Search users")

            } errorContent: { error in
                ContentUnavailableView {
                    Text("\(error.code)")
                    Text("\(error.localizedDescription)")
                }
            }
        }
        .navigationTitle("Users")
        .environment(userControllViewModel)
        .onAppear {
            Task {
                await userControllViewModel.loadUsers()
            }
        }
    }
}

#Preview {
    UsersControllView()
}
