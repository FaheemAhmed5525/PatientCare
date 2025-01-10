//
//  LoginView.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 03/01/2025.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = AuthViewModel()
    @Binding var showAuthView: Bool
    
    var body: some View {
        VStack {
            // Title
            Text("Login")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .fontWeight(.bold)
                .padding()
            
            // Input Fields
            VStack(alignment: .leading, spacing: 16) {
                // Email Field
                Text("Email")
                    .font(.headline)
                    .fontWeight(.bold)
                
                TextField("Enter your email", text: $viewModel.email)
                    .padding()
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                // Password Field
                Text("Password")
                    .font(.headline)
                    .fontWeight(.bold)
                
                SecureField("Enter your password", text: $viewModel.password)
                    .padding()
                    .background(Color.blue.opacity(0.08))
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
//            // Forgot Password Link
//            HStack {
//                Spacer()
//                NavigationLink {
//                    PasswordRecoveryView(showAuthView: $showAuthView)
//                } label: {
//                    Text("Forgot Password?")
//                        .font(.subheadline)
//                        .foregroundColor(.blue)
//                        .underline()
//                }
//            }
//            .padding([.horizontal, .top])
            
            // Message and Login Button
            VStack(spacing: 16) {
                // Status Message
                if !viewModel.message.isEmpty {
                    Text(viewModel.message)
                        .font(.headline)
                        .foregroundColor(viewModel.messageColor)
                        .multilineTextAlignment(.center)
                }
                
                // Login Button
                Button {
                    handleLoginAction()
                } label: {
                    Text("Login")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding(.top)
        }
        .padding(.horizontal)
        
        Spacer()
    }
    
    private func handleLoginAction() {
        viewModel.signInPatient { outcome in
            switch outcome {
            case .emptyInput:
                showMessage("Empty email or password!", color: .red)
            case .invalid:
                showMessage("Invalid email or password!", color: .red)
            case .unAuthorized:
                showMessage("Only patients can SignIn here!", color: .red)
            case .checking:
                showMessage("Checking account details...", color: .green)
            case .authorized:
                showMessage("Authentication completed", color: .green)
                showAuthView = false
            }
        }
    }
    
    private func showMessage(_ message: String, color: Color) {
        viewModel.message = message
        viewModel.messageColor = color
    }
}

#Preview {
    LoginView(showAuthView: .constant(true))
}
