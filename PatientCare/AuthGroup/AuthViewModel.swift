//
//  AuthViewModel.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 03/01/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
final class AuthViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var message: String = ""
    @Published var messageColor: Color = .white
    
    // MARK: - Public Methods
    func signInPatient(completion: @escaping (AuthOutCome) -> Void) {
        // Validate input
        guard !email.isEmpty, !password.isEmpty else {
            message = "Email and password cannot be empty"
            messageColor = .red
            completion(.emptyInput)
            return
        }
        
        Task {
            do {
                // Account authentication
                let authResult = try await AuthManager.shared.loginUser(email: email, password: password)
                handleLoginSuccess(authResult: authResult, completion: completion)
            } catch {
                message = "Invalid email or password"
                messageColor = .red
                completion(.invalid)
            }
        }
    }
    
    // MARK: - Private Methods
    private func handleLoginSuccess(authResult: AuthDataModel, completion: @escaping (AuthOutCome) -> Void) {
        print("Login successful")
        print("User ID: \(authResult.uid)")
        
        completion(.checking)
        
        // Role Authorization
        FirebaseManager.shared.isPatient(userId: authResult.uid) { [weak self] isPatient in
            guard let self = self else { return }
            
            if isPatient {
                completion(.authorized)
            } else {
                self.handleUnauthorizedAccess(completion: completion)
            }
        }
    }
    
    private func handleLoginFailure(completion: @escaping(AuthOutCome)->Void) {
        message = "Invalid email or password"
        messageColor = .red
        completion(.invalid)
    }
    
    private func handleUnauthorizedAccess(completion: @escaping (AuthOutCome) -> Void) {
        Task {
            do {
                try AuthManager.shared.signOut()
            } catch {
                message = "Error while signing out"
                messageColor = .red
                print("Error while signing out: \(error.localizedDescription)")
            }
        }
        
        message = "Only patients can sign in here"
        messageColor = .orange
        completion(.unAuthorized)
    }
}

enum AuthOutCome {
    case emptyInput
    case authorized
    case unAuthorized
    case invalid
    case checking
}
