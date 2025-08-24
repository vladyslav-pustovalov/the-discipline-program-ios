//
//  MainView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(AuthViewModel.self) var authViewModel
    @State var programDate = Date.now
    let notificationController = LocalNotificationController()
    
    var body: some View {
        TabView {
            NavigationStack {
                ProgramView(for: programDate)
            }
            .tabItem {
                Label("Program", systemImage: "list.dash")
            }
            
            if authViewModel.userRole == UserRole.roleAdmin {
                NavigationStack {
                    CreateProgramView()
                }
                .tabItem {
                    Label("Create Program", systemImage: "document.badge.plus")
                }
            }
            
            NavigationStack {
                UserView()
            }
            .tabItem {
                Label("User", systemImage: "person.circle")
            }
        }
        .onAppear(perform: notificationController.setUserNotification)
    }
}

#Preview {
    MainView()
        .environment(AuthViewModel())
}
