//
//  ContentView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct ContentView: View {
    @State var isAuthenticate = false
    
    var body: some View {
        if isAuthenticate {
            MainView()
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
