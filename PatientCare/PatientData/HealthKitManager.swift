//
//  HealthKitManager.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 08/01/2025.
//

import Foundation
import HealthKit

class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    //MARK: - Public methods
    func fetchHealthData(completion: @escaping(PatientDataModel?)->Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health Data unavailable")
            completion(nil)
            return
        }
        
        //quantities to be read
        //QT: QuantityType
        let heartRateQT = HKQuantityType(.heartRate)
        let bloodPressureSystolicQT = HKQuantityType(.bloodPressureSystolic)
        let bloodPressureDiastolicQT = HKQuantityType(.bloodPressureSystolic)
        let bloodOxygenQT = HKQuantityType(.oxygenSaturation)
        let bodyTempQT = HKQuantityType(.bodyTemperature)
        
        let healthStoreQuantityTypes: Set = [heartRateQT, bloodOxygenQT, bloodOxygenQT, bodyTempQT]
        //request data fetch
        healthStore.requestAuthorization(toShare: nil, read: healthStoreQuantityTypes) { (success, error)  in
            
            if success {
                //fetching data
                self.fetchUpdateData(for: heartRateQT) { heartRate in
                    self.fetchUpdateData(for: bloodPressureSystolicQT) { bloodPressureSystolic in
                        self.fetchUpdateData(for: bloodPressureDiastolicQT) { bloodPressureDiastolic in
                            self.fetchUpdateData(for: bloodOxygenQT) { bloodOxygen in
                                self.fetchUpdateData(for: bodyTempQT) { bodyTemp in
                                    print("Heart Rate: \(heartRate)")
                                    print("BP Systolic: \(bloodPressureSystolic)")
                                    print("BP Diastolic: \(bloodPressureDiastolic)")
                                    print("Blood oxygen: \(bloodOxygen)")
                                    print("Body Temp: \(bodyTemp)")
                                    let patientData = PatientDataModel(
                                        bloodOxygen: Float(bloodOxygen),
                                        bloodPressureSystolic: Int(bloodPressureSystolic),
                                        bloodPressureDiastolic: Int(bloodPressureDiastolic),
                                        heartRate: Int(heartRate),
                                        bodyTemprature: Float(bodyTemp),
                                        recordTime: Date()
                                    )
                                    completion(patientData)
                                }
                            }
                        }
                    }
                }
            }
            else {
                completion(nil)
            }
        }
    }
    
    
    
    func requestHealthKitAccess(completion: @escaping(Bool)->Void) {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit is not available on this device.")
            completion(false)
            return
        }

        let healthStore = HKHealthStore()

        guard let bloodPressureSystolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic),
              let bloodPressureDiastolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic),
              let bodyTemperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature),
              let oxygenSaturationType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation),
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Unable to create one or more health data types.")
            completion(false)
            return
        }

        let typesToShare: Set = [bloodPressureSystolicType, bloodPressureDiastolicType, bodyTemperatureType, oxygenSaturationType, heartRateType]
        let typesToRead: Set = [bloodPressureSystolicType, bloodPressureDiastolicType, bodyTemperatureType, oxygenSaturationType, heartRateType]

        // Request authorization
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if let error = error {
                print("Authorization error: \(error.localizedDescription)")
                completion(false)
            } else if success {
                print("HealthKit authorization granted.")
                completion(true)
            } else {
                print("HealthKit authorization denied.")
                completion(false)
            }
        }
    }
    
    func checkHealthKitAuthorization() -> Bool {

        // Define the data types to check
        guard let bloodPressureSystolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureSystolic),
              let bloodPressureDiastolicType = HKObjectType.quantityType(forIdentifier: .bloodPressureDiastolic),
              let bodyTemperatureType = HKObjectType.quantityType(forIdentifier: .bodyTemperature),
              let oxygenSaturationType = HKObjectType.quantityType(forIdentifier: .oxygenSaturation),
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            print("Unable to create one or more health data types.")
            return false
        }

        // Check authorization status for all types
        let types = [bloodPressureSystolicType, bloodPressureDiastolicType, bodyTemperatureType, oxygenSaturationType, heartRateType]
        
        let allAuthorized = types.allSatisfy { healthStore.authorizationStatus(for: $0) == .sharingAuthorized }
        if allAuthorized {
            print("-------------App is authorized to access data")
        } else {
            print("-------------App is not authorized to access data")
        }
        return allAuthorized
    }
    
    
    
    
    
    //MARK: - Private function
    func fetchUpdateData(for quantityType: HKQuantityType, completion: @escaping(Double)->Void) {
        let query = HKSampleQuery(sampleType: quantityType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { (_, samples, _) in
            if let sample = samples?.first as? HKQuantitySample {
                completion(sample.quantity.doubleValue(for: HKUnit(from: quantityType.identifier)))
            } else {
                completion(0.0)
            }
        }
        healthStore.execute(query)
    }
}
