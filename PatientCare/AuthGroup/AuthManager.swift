//
//  AuthManager.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 03/01/2025.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    
    //current user of the session
    func getCurrentUser() throws -> AuthDataModel {
        guard let user = Auth.auth().currentUser else {
            print("Can't get current user")
            throw URLError(.badServerResponse)
        }
        print("Getting user, \(user.uid)")
        
        return AuthDataModel(user: user)
    }
    
    ///Log in any user
    func loginUser(email: String, password: String) async throws -> AuthDataModel {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataModel(user: authResult.user)
    }
    
    
    //log out user
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
}
