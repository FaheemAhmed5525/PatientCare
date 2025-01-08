//
//  AuthDataModel.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 03/01/2025.
//

import Foundation
import FirebaseAuth

struct AuthDataModel {
    let uid: String
    let email: String?
    let photoURL: URL?
    
    init(uid: String, name: String?, photoURL: URL?) {
        self.uid = uid
        self.email = name
        self.photoURL = photoURL
    }
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL
    }
    
    
}
