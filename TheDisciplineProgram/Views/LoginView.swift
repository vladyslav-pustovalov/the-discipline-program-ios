//
//  LoginView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) var authViewModel
    
    var body: some View {
        @Bindable var authViewModel = authViewModel
        
        ZStack {
            Color.gray.opacity(0.03)
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 100)
                
                Spacer()
                                
                VStack(spacing: 15) {
                    TextField("Email", text: $authViewModel.email)
                        .padding()
                        .frame(width: 300)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .textContentType(.username)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $authViewModel.password)
                        .padding()
                        .frame(width: 300)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .textContentType(.password)
                }
                .padding()
                
                Button {
                    authViewModel.performLogin()
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .font(.title2)
                            .bold()
                    }
                }
                .frame(width: 300, height: 60)
                .background(
                    LinearGradient(
                        colors: authViewModel.isLoginButtonDisabled
                        ? [.gray.opacity(0.5)]
                        : [.gray.opacity(0.2), .gray.opacity(0.8)],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .disabled(authViewModel.isLoginButtonDisabled)
                
                Spacer()
                Spacer()
                
            }
        }
        .alert("Authentication failed", isPresented: $authViewModel.showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Something went wrong during auth attempt, check your login and password please")
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthViewModel())
}
