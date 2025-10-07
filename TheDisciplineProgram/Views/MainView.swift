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
    @State var programDate: Date
    @State var notificationViewModel: LocalNotificationViewModel
    
    init() {
        self._notificationViewModel = State(initialValue: LocalNotificationViewModel())
        programDate = Date.now
    }
    
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
                
                NavigationStack {
                    UsersControllView()
                }
                .tabItem {
                    Label("Users Control", systemImage: "person.2.badge.gearshape.fill")
                }
            }
            
            NavigationStack {
                UserView()
            }
            .tabItem {
                Label("User", systemImage: "person.circle")
            }
        }
        .onAppear(perform: notificationViewModel.setUserNotification)
        .alert("Notifications are disabled", isPresented: $notificationViewModel.isShowingAlert) {
            Button("Go to Settings") {
                notificationViewModel.openAppSettings()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("To enable reminders, please allow notifications in Settings.")
        }
    }
}

#Preview {
    MainView()
        .environment(AuthViewModel())
}
