import Foundation
import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    @Binding var showAuthView: Bool
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                // Emergency Button
                Button(action: {
                    print("Emergency Button tapped")
                    viewModel.onEmergencyButtonTap()
                }) {
                    ZStack {
                        // Outer empty circle
                        Circle()
                            .stroke(Color.red, lineWidth: 4)
                            .frame(width: 140, height: 140)
                        
                        // Inner filled circle
                        Circle()
                            .fill(Color.red)
                            .frame(width: 110, height: 110)
                        
                        Text("Emergency")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onAppear {
                    viewModel.startTimer()
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 40)
                
                Spacer()
                
                // Logout Button
                Button {
                    Task {
                        do {
                            try viewModel.logOut()
                            showAuthView = true
                        } catch {
                            print("Logout failed: \(error.localizedDescription)")
                        }
                    }
                } label: {
                    Text("Logout")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                // NavigationLink to SimulationView
                NavigationLink(destination: SimulationView()) {
                    Text("Add Health Values")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("")
        }
    }
    
    
}

#Preview {
    HomeView(showAuthView: .constant(true))
}

//struct Entity: Identifiable {
//    let id = UUID()
//    let name: String
//    let value: String
//    let icon: Image
//}
