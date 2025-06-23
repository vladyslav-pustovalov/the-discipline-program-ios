//
//  MainView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @Environment(AppState.self) var appState
    @State var programDate = Date.now
    @State public var auth = false
    
    var body: some View {
        if !appState.isAuthenticated {
            LoginView()
        } else {
            TabView {
                NavigationStack {
                    ProgramView(for: programDate)
                }
                .tabItem {
                    Label("Program", systemImage: "list.dash")
                }
                
                NavigationStack {
                    UserView()
                }
                .tabItem {
                    Label("User", systemImage: "person.circle")
                }
            }
        }
    }
}

#Preview {
    MainView()
        .environment(AppState())
}
