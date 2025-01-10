//
//  ContentView.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 03/01/2025.
//

import SwiftUI

struct RootView: View {
    
    @State private var showAuthView: Bool = false
    
    var body: some View {
        NavigationStack {
            // Main HomeView, if authenticated, show the HomeView, otherwise show login screen
            HomeView(showAuthView: $showAuthView)
        }
        .onAppear {
            // Attempt to get the current user and show login view if not authenticated
            checkUserAuthentication()
        }
        .fullScreenCover(isPresented: $showAuthView, content: {
            // If user is not authenticated, show the LoginView
            NavigationStack {
                LoginView(showAuthView: $showAuthView)
            }
        })
    }
    
    // Method to check if user is authenticated
    private func checkUserAuthentication() {
        do {
            // Fetch the current user
            let authResult = try AuthManager.shared.getCurrentUser()
            // If no user is found, show the auth view
            self.showAuthView = authResult == nil
        } catch {
            // Handle any potential errors gracefully (e.g., failed to check user)
            print("Error checking current user: \(error)")
            self.showAuthView = true // Show the auth view if there's an error
        }
    }
}

#Preview {
    RootView()
}
