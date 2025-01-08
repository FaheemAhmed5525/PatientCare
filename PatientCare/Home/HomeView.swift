//
//  HomeView.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 03/01/2025.
//

import Foundation
import SwiftUI


class HomeViewModel: ObservableObject {
    
    func logOut() throws {
        try AuthManager.shared.signOut()
    }
}



struct HomeView: View {
    
    
    @StateObject private var viewModel = HomeViewModel()
    @Binding var showAuthView: Bool
    
    var body: some View {
        Button {
            Task {
                do {
                    try viewModel.logOut()
                    showAuthView = true
                } catch {
                    
                }
            }
        } label: {
            Text("Logout")
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.blue)
                .cornerRadius(12)
        }
        .padding()
    }
}

#Preview {
    HomeView(showAuthView: .constant(true))
}


struct Entity: Identifiable {
    let id = UUID()
    let name: String
    let value: String
    let icon: Image
}
