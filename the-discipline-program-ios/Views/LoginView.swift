//
//  LoginView.swift
//  the-discipline-program-ios
//
//  Created by Vladyslav Pustovalov on 17/05/2025.
//

import SwiftUI

struct LoginView: View {
    @Environment(AppState.self) var appState
    @Bindable private var viewModel: ViewModel
    
    private var isDisabled: Bool {
        viewModel.email.isEmpty || viewModel.password.isEmpty
    }
    
    init() {
        viewModel = ViewModel()
    }
    
    var body: some View {
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
                
                Button(action: viewModel.performLogin) {
                    Text("Sign In")
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.white)
                        .font(.title2)
                        .bold()
                }
                .frame(width: 300, height: 60)
                .background(
                    LinearGradient(
                        colors: isDisabled
                        ? [.gray.opacity(0.6)]
                        : [.blue, .yellow],
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .disabled(isDisabled)
                
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
        .onAppear {
            self.viewModel.setup(self.appState)
        }
    }
}

#Preview {
    LoginView()
        .environment(AppState())
}
