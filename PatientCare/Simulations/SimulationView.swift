//
//  SimulationView.swift
//  PatientCare
//
//  Created by Faheem Ahmed on 09/01/2025.
//

import SwiftUI

struct SimulationView: View {
    
    @StateObject var viewModel = SimulationViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            Group {
                InputField(label: "Heart Rate", value: Binding(
                    get: { String(viewModel.heartRate) },
                    set: { viewModel.heartRate = Int($0) ?? 0 }
                ))
                InputField(label: "BP Systolic", value: Binding(
                    get: { String(viewModel.bloodPressureSystolic) },
                    set: { viewModel.bloodPressureSystolic = Int($0) ?? 0 }
                ))
                InputField(label: "BP Diastolic", value: Binding(
                    get: { String(viewModel.bloodPressureDiastolic) },
                    set: { viewModel.bloodPressureDiastolic = Int($0) ?? 0 }
                ))
                InputField(label: "Oxygen Level", value: Binding(
                    get: { String(viewModel.bloodOxygen) },
                    set: { viewModel.bloodOxygen = Float($0) ?? 0 }
                ))
                InputField(label: "Body Temperature", value: Binding(
                    get: { String(viewModel.bodyTemp) },
                    set: { viewModel.bodyTemp = Float($0) ?? 0 }
                ))
            }
            
            Button {
                viewModel.pushData()
                
            } label: {
                Text("Add Data")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.top)
        }
        .padding()
    }
}

struct InputField: View {
    let label: String
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.headline)
                .fontWeight(.bold)
            TextField(label, text: $value)
                .padding()
                .background(Color.blue.opacity(0.08))
                .cornerRadius(12)
                .keyboardType(.numberPad)
                .autocapitalization(.none)
        }
    }
}


#Preview {
    SimulationView()
}
