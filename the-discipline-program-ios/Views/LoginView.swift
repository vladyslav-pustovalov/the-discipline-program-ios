//
//  LoginView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email = "vlad@mail.com"
    @State private var password = "vlad123"
    @State private var showingAlert = false
    @State private var authStatus: NetworkResponseStatus?
    
    @Binding var authToken: String?
    @Binding var userId: Int?
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            Button("Login", action: performLogin)
                .disabled(email.isEmpty || password.isEmpty)
        }
        .alert("Authentication failed", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
        } message: {
            if let authStatus {
                Text("Error status: \(authStatus.code)")
                Text("Error message: \(authStatus.description)")
            }
        }
    }
    
    func performLogin() {
        Task {
            do {
                let result = try await NetworkManager.shared.login(email: email, password: password)
                switch result {
                case .success(let jwt):
                    saveJWTDataToDefaults(jwt: jwt)
                    authToken = jwt.accessToken
                    userId = jwt.userId
                    isAuthenticated = true
                case .failure(let status):
                    authStatus = status
                    showingAlert = true
                }
            } catch {
                print("❌ Login failed: \(error)")
                print("Error message: \(error.localizedDescription)")
            }
        }
    }
    
    func saveJWTDataToDefaults(jwt: JwtDTO) {
        UserDefaults.standard.set(jwt.accessToken, forKey: Constants.Defaults.accessToken)
        UserDefaults.standard.set(jwt.userId, forKey: Constants.Defaults.userId)
    }
}

#Preview {
    @Previewable @State var authToken: String? = ""
    @Previewable @State var userId: Int? = 1
    @Previewable @State var isAuthenticated = false
    
    return LoginView(authToken: $authToken, userId: $userId, isAuthenticated: $isAuthenticated)
}
