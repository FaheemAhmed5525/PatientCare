//
//  SwiftUIView.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 08/01/2025.
//

import Foundation
import SwiftUI
import HealthKit

struct IdentifiableAlert: Identifiable {
    let id = UUID()
    let message: String
}

struct PermissionView: View {
    

    @Binding var hasPermission: Bool
    @State var alertMessage: IdentifiableAlert?
    
    var body: some View {
        VStack {
            Image("Patient Care")
                .resizable()
                .frame(maxWidth: .infinity)
                .scaledToFit()
                .padding()
            
            Text("Permission required")
                .font(.largeTitle)
                .fontWeight(.bold
                )
                .padding()
            Text("Patient needs permission to get your health data")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: requestHealthKitAccess) {
                Text("Accept & Continue")
                    .padding()
                    .foregroundColor(Color.white)
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8.0)
            }
            
        }
        .padding()
        .alert(item: $alertMessage) { alert in
            Alert(
                title: Text("Permission denied"),
                message: Text(alert.message),
                dismissButton: .destructive(Text("Exit app")) {
                    exitApp()
                }
                
            )
        }
    }
    
    private func requestHealthKitAccess() {
        HealthKitManager.shared.requestHealthKitAccess() { success in
            if success {
                print("Permission granted")
                self.hasPermission = true
                navigateToHome()
            } else {
                print("Permission denied")
                self.alertMessage = IdentifiableAlert(message: "Permission denied. Photo library access is required to edit pictures.")
            }
        }
    }
    
    private func navigateToHome() {
        
    }
    
    private func exitApp() {
        //Terminate the app
        DispatchQueue.main.asyncAfter(deadline: .now() + 01)  {
            exit(0)
        }
    }

   
}

#Preview {
    PermissionView(hasPermission: .constant(false))
}
