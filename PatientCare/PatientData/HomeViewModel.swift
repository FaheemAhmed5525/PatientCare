//
//  HomeViewModel.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 08/01/2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
    @Published var patientData: PatientDataModel?
    
    var timer: Timer?
    // Initializer to fetch patient data when ViewModel is created
    init() {
        fetchPatientData()
    }
    
    // Fetching HealthKit data and handling success/failure
    @objc func fetchPatientData() {
        HealthKitManager.shared.fetchHealthData { [weak self] data in
            DispatchQueue.main.async {
                self?.patientData = data
                if let data = data {
                    self?.pushToDatabase(data: data)
                } else {
                    print("Failed to fetch patient data.")
                }
            }
        }
    }
    
    // Push data to Firebase database
    func pushToDatabase(data: PatientDataModel) {
        Task {
            do {
                try await FirebaseManager.shared.pushDataToFirebase(data: data)
            } catch {
                print("Error pushing data to Firebase: \(error)")
            }
        }
    }
    
    // Handle Emergency Button tap event
    func onEmergencyButtonTap() {
        // Fetching and pushing data to the database
        self.fetchPatientData()
        
        // Pushing data to the emergency database if available
        guard let data = patientData else {
            print("No patient data to push for emergency.")
            return
        }
        
        Task {
            do {
                try await FirebaseManager.shared.pushDataToFirebase(data: data, to: "EmergencyCall")
            } catch {
                print("Error pushing data to emergency: \(error)")
            }
        }
    }
    
    // Log out method
    func logOut() throws {
        do {
            try AuthManager.shared.signOut()
        } catch {
            print("Failed to log out: \(error)")
            throw error
        }
    }
    
    
    //timer funciton
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 5,
            target: self,
            selector: #selector(fetchPatientData),
            userInfo: nil,
            repeats: true)
    }
    
    
//    // Fetching HealthKit data and handling success/failure
//    @objc func fetchPatientData() {
//        HealthKitManager.shared.fetchHealthData { data in
//            DispatchQueue.main.async {
//                if let data = data {
//                    Task {
//                        do {
//                            try await FirebaseManager.shared.pushDataToFirebase(data: data)
//                        } catch {
//                            print("Error pushing data to Firebase: \(error)")
//                        }
//                    }
//                } else {
//                    print("Failed to fetch patient data.")
//                }
//            }
//        }
//    }
}
