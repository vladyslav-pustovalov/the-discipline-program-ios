//
//  MainView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftData
import SwiftUI

struct MainView: View {
    @State var programDate = Date.now
    @State var userViewModel = UserViewModel()
    
    var body: some View {
        TabView {
            NavigationStack {
                ProgramView(for: programDate)
            }
            .tabItem {
                Label("Program", systemImage: "list.dash")
            }
            
            NavigationStack {
                UserView(userViewModel: userViewModel)
            }
            .tabItem {
                Label("User", systemImage: "person.circle")
            }
        }
    }
}

#Preview {
    MainView()
}
