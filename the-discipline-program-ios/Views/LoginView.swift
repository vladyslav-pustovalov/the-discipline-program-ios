//
//  LoginView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthViewModel.self) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        ZStack {
            Color.gray.opacity(0.03)
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome!")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 100)
                
                VStack(spacing: 15) {
                    TextField("Email", text: $viewModel.email)
                        .padding()
                        .frame(width: 300)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .frame(width: 300)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding()
                
                Button {
                    viewModel.performLogin(email: viewModel.email, password: viewModel.password)
                } label: {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .font(.title2)
                        .bold()
                }
                .frame(width: 300, height: 60)
                .background(
                    LinearGradient(
                        colors: viewModel.isLoginButtonDisabled
                        ? [.gray.opacity(0.6)]
                        : [.gray, .black],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .disabled(viewModel.isLoginButtonDisabled)
                
                Spacer()
                                
                }
                
                Spacer()
                
            
        }
        .alert("Authentication failed", isPresented: $viewModel.showingAlert) {
                    Button("OK", role: .cancel) { }
        } message: {
            Text("Error status: \(viewModel.authStatus?.code)")
            Text("Error message: \(viewModel.authStatus?.description)")
        }
    }
}

#Preview {
    LoginView()
}
