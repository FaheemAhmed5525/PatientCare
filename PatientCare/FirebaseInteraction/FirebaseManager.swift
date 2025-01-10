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
    private let database = Firestore.firestore()
    
    private init() {}
    
    // Check if the user is a patient
    func isPatient(userId: String, completion: @escaping (Bool) -> Void) {
        // Reference to the "Patient" document
        let patientRef = database.collection("Patient").document(userId)
        print("Checking for patient with User ID: \(userId)")
        
        patientRef.getDocument { (document, error) in
            if let error = error {
                print("Error occurred while fetching patient data: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let document = document, document.exists {
                // Retrieving patient name
                let name = document.get("Name") as? String ?? "Unknown"
                print("Patient name: \(name)")
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // Push patient data to Firestore
    func pushDataToFirebase(data: PatientDataModel, to collection: String = "Data") async throws {
        guard let userId = AuthManager.shared.user?.uid else {
            throw NSError(domain: "FirebaseManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])
        }
        
        let dataDictionary: [String: Any] = [
            "BloodOxygen": data.bloodOxygen,
            "BloodPressureSystolic": data.bloodPressureSystolic,
            "BloodPressureDiastolic": data.bloodPressureDiastolic,
            "BodyTemprature": data.bodyTemprature,
            "HeartRate": data.heartRate,
            "RecordTime": data.recordTime
        ]
        
        let timeStamp = ISO8601DateFormatter().string(from: data.recordTime)
        
        // Push the data to Firestore
        let documentRef = database.collection("Patient").document(userId).collection(collection).document(timeStamp)
        
        do {
            try await documentRef.setData(dataDictionary)
            print("Patient data pushed successfully to Firestore")
        } catch let error {
            print("Error while pushing patient data: \(error.localizedDescription)")
            throw error
        }
    }
}

