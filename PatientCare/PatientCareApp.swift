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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var isPermissionGranted = HealthKitManager.shared.checkHealthKitAuthorization()
    
    var body: some Scene {
        WindowGroup {
            if isPermissionGranted {
                RootView()
            } else {
                PermissionView(hasPermission: $isPermissionGranted)
            }
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("Firebase initilized")
        
        // Set Firebase logging level to minimize logs
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        return true
    }
}
