//
//  PatientCareApp.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 03/01/2025.
//

import SwiftUI
import Firebase

@main
struct PatientCareApp: App {
    
    // AppDelegate integration for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Check HealthKit authorization status
    @State private var isPermissionGranted = HealthKitManager.shared.checkHealthKitAuthorization()
    
    var body: some Scene {
        WindowGroup {
            // Show appropriate view based on HealthKit permission status
            Group {
                if isPermissionGranted {
                    RootView()
                } else {
                    PermissionView(hasPermission: $isPermissionGranted)
                }
            }
        }
    }
}

// AppDelegate class to handle Firebase initialization
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        print("Firebase initialized")
        
        // Set Firebase logging level to minimize logs
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        return true
    }
}
