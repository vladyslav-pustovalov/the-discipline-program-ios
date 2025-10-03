//
//  ContentView.swift
//  TheDisciplineProgram
//
//  Created by Vladyslav Pustovalov on 19/07/2025.
//

import SwiftUI

struct ContentView: View {
    @State var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainView()
            } else {
                LoginView()
            }
        }
        .environment(authViewModel)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}

