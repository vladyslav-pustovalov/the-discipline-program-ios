//
//  MainView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @State var programDate = Constants.Formatter.dateFormatter.date(from: "2024-06-07")!
    @EnvironmentObject var appState: AppState
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
}
