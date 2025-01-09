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
    @Published var user: AuthDataModel?
    
    private init() {}
    
    
    //current user of the session
    func getCurrentUser() throws -> AuthDataModel {
        guard let user = Auth.auth().currentUser else {
            print("Can't get current user")
            throw URLError(.badServerResponse)
        }
        print("Getting user, \(user.uid)")
        self.user = AuthDataModel(user: user)
        return AuthDataModel(user: user)
    }
    
    ///Log in any user
    func loginUser(email: String, password: String) async throws -> AuthDataModel {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        self.user = AuthDataModel(user: authResult.user)
        return AuthDataModel(user: authResult.user)
    }
    
    
    //log out user
    func signOut() throws {
        try Auth.auth().signOut()
        self.user = nil
    }
    
}
