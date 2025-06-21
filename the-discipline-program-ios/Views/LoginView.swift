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
    @Binding var authToken: String?
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            Button("Login", action: login)
            .disabled(email.isEmpty || password.isEmpty)
        }
    }
    
    func login() {
        guard let url = URL(string: "http://127.0.0.1:8080/api/v1/auth/signin") else {
            print("Invalid URL")
            return
        }
        
        let json = SignInDTO(login: email, password: password)
        guard let body = try? JSONEncoder().encode(json) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.httpBody = body
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let jwt = try? JSONDecoder().decode(JwtDTO.self, from: data)
                authToken = jwt?.accessToken
                isAuthenticated = true
                print("Token: \(authToken ?? "NONE")")
            } else {
                print("Unexpected error")
            }
        }
        task.resume()
    }
}

#Preview {
    @Previewable @State var authToken: String? = ""
    @Previewable @State var isAuthenticated = false
    
    return LoginView(authToken: $authToken, isAuthenticated: $isAuthenticated)
}
