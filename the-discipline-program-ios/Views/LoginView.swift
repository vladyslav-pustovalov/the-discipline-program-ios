//
//  LoginView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var authToken: String?
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
            TextField("Password", text: $password)
            Button("Login", action: login)
                .disabled(email.isEmpty || password.isEmpty)
        }
    }
    
    func login() {
        //maybe do some guards
        //send auth request with login and password
        //receive the auth token
        //authToken = receivedToken
    }
}

#Preview {
    LoginView()
}
