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
            HomeView(showAuthView: $showAuthView)
        }
        .onAppear {
            let authResult = try? AuthManager.shared.getCurrentUser()
            self.showAuthView = authResult == nil
            
        }
        .fullScreenCover(isPresented: $showAuthView, content: {
            NavigationStack {
                LoginView(showAuthView: $showAuthView)
            }
        })
        
    }
}

#Preview {
    RootView()
}
