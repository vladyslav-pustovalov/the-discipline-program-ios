//
//  MainView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ProgramView()
                .tabItem {
                    Label("Program", systemImage: "list.dash")
                }
            TeamView()
                .tabItem {
                    Label("Team", systemImage: "person.3")
                }
            UserView()
                .tabItem {
                    Label("User", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView()
}
