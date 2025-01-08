//
//  FirebaseManager.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 06/01/2025.
//

import Foundation
import Firebase
import FirebaseFirestore

final class FirebaseManager {
    static let shared = FirebaseManager()
    let database = Firestore.firestore()
    
    private init() {}
    
    func isPatient(userId: String, complition: @escaping(Bool)->Void){
        
        //get the patient if exits:
        let data = Firestore.firestore().collection("Patient").document(userId)
        print("Userid: \(userId)")
        
        data.getDocument { (document, error) in
            if let error = error {
                print("Error occured \(error.localizedDescription)")
                complition(false)
                return
            }
            
            if let document = document, document.exists {
                
                ///Retriving the data
                let name = document.get("Name") as? String ?? ""
                print("Patient name: \(name)")
                complition(true)
                return
            }
            complition(false)
        }
    }

}
