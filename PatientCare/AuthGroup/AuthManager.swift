//
//  AuthManager.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 03/01/2025.
//

import Foundation
import FirebaseAuth

final class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Published private(set) var user: AuthDataModel?
    
    private init() {}
    
    // Get the current user session
    func getCurrentUser() throws -> AuthDataModel {
        guard let currentUser = Auth.auth().currentUser else {
            print("No current user found")
            throw URLError(.userAuthenticationRequired)
        }
        print("Getting user: \(currentUser.uid)")
        self.user = AuthDataModel(user: currentUser)
        return self.user!
    }
    
    /// Log in user with email and password
    func loginUser(email: String, password: String) async throws -> AuthDataModel {
        do {
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = AuthDataModel(user: authResult.user)
            return self.user!
        } catch {
            print("Error signing in: \(error.localizedDescription)")
            throw error
        }
    }
    
    // Sign out the current user
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.user = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            throw error
        }
    }
}
