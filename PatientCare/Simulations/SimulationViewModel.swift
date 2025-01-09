//
//  SimulationViewModel.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 09/01/2025.
//

import Foundation

final class SimulationViewModel: ObservableObject {
    @Published var heartRate: Int = 0
    @Published var bloodPressureSystolic: Int = 0
    @Published var bloodPressureDiastolic: Int = 0
    @Published var bloodOxygen: Float = 0
    @Published var bodyTemp: Float = 0
    
    
    init() {
        
    }
    
    
    func pushData() {
        let patientData = PatientDataModel(
            bloodOxygen: self.bloodOxygen,
            bloodPressureSystolic: self.bloodPressureSystolic,
            bloodPressureDiastolic: self.bloodPressureDiastolic,
            heartRate: self.heartRate,
            bodyTemprature: self.bodyTemp,
            recordTime: Date()
        )
        Task {
            do {
                try await FirebaseManager.shared.pushDataToFirebase(data: patientData)
            }
            catch {
                
            }
        }
    }
}
