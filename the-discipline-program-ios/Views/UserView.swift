//
//  UserView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        if let user = viewModel.user {
            VStack {
                List {
                    Text("Email: \(user.login)")
                    Text("First name: \(user.firstName ?? "")")
                    Text("Last name: \(user.lastName ?? "")")
                    Text("Level: \(user.trainingLevel?.name ?? "")")
                    Text("Birthday: \(Constants.Formatter.dateFormatter.string(from: user.dateOfBirth ?? Date.now))")
                    Text("Phone: \(user.phoneNumber ?? "")")
                }
                
                Button("Sign Out", role: .destructive) {
                    viewModel.signOut()
                }
                    .buttonStyle(.bordered)
                    .padding(5)
                
                Rectangle()
                    .frame(height: 0.2)
                    .opacity(0.5)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                    }
                }
            }
            .onAppear {
                self.viewModel.setup(self.appState)
            }
        } else {
            ContentUnavailableView {
                Text("Something went wrong with loading user's data")
            }
        }
    }
}

#Preview {
    return UserView()
}
