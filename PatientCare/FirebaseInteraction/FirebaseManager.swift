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
    
    
    func pushDataToFirebase(data: PatientDataModel, to inCollection: String = "Data") async throws {
        if let userId = AuthManager.shared.user?.uid {
            
            let dataDictionary: [String: Any] = [
                "BloodOxygen": data.bloodOxygen,
                "BloodPressureSystolic": data.bloodPressureSystolic,
                "BloodPressureDiastolic" : data.bloodPressureDiastolic,
                "BodyTemprature": data.bodyTemprature,
                "HeartRate": data.heartRate,
                "RecordTime": data.recordTime
            ]
            
            let timeStamp = ISO8601DateFormatter().string(from: data.recordTime)
            
            
            DispatchQueue.main.async {
                Firestore.firestore().collection("Patient").document(userId).collection(inCollection).document(timeStamp).setData(dataDictionary) { error in
                    if let error = error {
                        print("Error while pushing patient data: \(error)")
                    } else {
                        print("Patient data pushed successfully")
                    }
                }
                
            }
        }
    }

}


