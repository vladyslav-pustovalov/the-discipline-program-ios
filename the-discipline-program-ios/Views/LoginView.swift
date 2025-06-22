//
//  LoginView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel: ViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ViewModel())
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $viewModel.email)
            TextField("Password", text: $viewModel.password)
            Button("Login", action: viewModel.performLogin)
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)
        }
        .alert("Authentication failed", isPresented: $viewModel.showingAlert) {
                    Button("OK", role: .cancel) { }
        } message: {
            Text("Error status: \(viewModel.authStatus?.code)")
            Text("Error message: \(viewModel.authStatus?.description)")   
        }
        .onAppear {
            self.viewModel.setup(self.appState)
        }
    }
}

#Preview {
    @Previewable @State var authToken: String? = ""
    @Previewable @State var userId: Int? = 1
    @Previewable @State var isAuthenticated = false
    return LoginView()
}
