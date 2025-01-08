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
            print("Empty email or password!")
            completion(.emptyInput)
            return
        }
        
        Task {
            do {
                // Account authentication
                let authResult = try await AuthManager.shared.loginUser(email: email, password: password)
                handleLoginSuccess(authResult: authResult, completion: completion)
                
            } catch {
                handleLoginFailure(completion: completion)
            }
        }
    }
    
    // MARK: - Private Methods
    private func handleLoginSuccess(authResult: AuthDataModel, completion: @escaping (AuthOutCome) -> Void) {
        print("Login successful")
        print(authResult.uid)
        
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
        print("Invalid email or password")
        completion(.invalid)
    }
    
    private func handleUnauthorizedAccess(completion: @escaping (AuthOutCome) -> Void) {
        Task {
            do {
                try AuthManager.shared.signOut()
            } catch {
                print("Error while signing out")
            }
        }
        
        print("Only patients can sign in here")
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
