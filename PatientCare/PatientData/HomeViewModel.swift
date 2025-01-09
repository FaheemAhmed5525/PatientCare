//
//  HomeViewModel.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 08/01/2025.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
    @Published var patientData: PatientDataModel?
    
    init() {
        fetchPatientData()
    }
    
    func fetchPatientData() {
        HealthKitManager.shared.fetchHealthData() { data in
            DispatchQueue.main.async {
                self.patientData = data
                if let data = data {
                    self.pushToDatabase(data: data)
                }
            }
        }
    }
    
    
    func pushToDatabase(data: PatientDataModel) {
        Task {
            do {
                try await FirebaseManager.shared.pushDataToFirebase(data: data)
            }
            catch {}
        }
    }
    
    func onEmergencyButtonTap () {
        
        //fetching and pushing data to database
        self.fetchPatientData()
        //pushing data to emergency database
        if let data = self.patientData {
            Task {
                do {
                    try await FirebaseManager.shared.pushDataToFirebase(data: data, to: "EmergencyCall")
                }
                catch {}
            }
        }
        else {
            print("No data to push")
        }
    }
    
    func logOut() throws {
        try AuthManager.shared.signOut()
    }
    
}
