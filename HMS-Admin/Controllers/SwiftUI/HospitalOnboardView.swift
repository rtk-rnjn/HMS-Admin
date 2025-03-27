//
//  HospitalOnboardView.swift
//  HMS-Admin
//
//  Created by Suryansh Srivastav on 27/03/25.
//

import SwiftUI

struct HospitalOnboardView: View {
    // Callback for when setup is completed
    var onSetupCompleted: (() -> Void)?
    
    @State private var hospitalName = ""
    @State private var location = ""
    @State private var contactNumber = ""
    @State private var licenseNumber = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Hospital Information")) {
                    TextField("Hospital Name", text: $hospitalName)
                    TextField("Location", text: $location)
                    TextField("Pin Code", text: $contactNumber)
                    TextField("Hospital License Number", text: $licenseNumber)
                }
                
                Section {
                    Button(action: {
                        if isFormValid {
                            saveHospitalInfo()
                            onSetupCompleted?()
                        }
                    }) {
                        Text("Complete Setup")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(isFormValid ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle("Hospital Setup")
            .background(Color(.systemGroupedBackground))
        }
        .onAppear {
            // Debug help
            print("HospitalOnboardView appeared")
        }
    }
    
    private var isFormValid: Bool {
        return !hospitalName.isEmpty && !location.isEmpty && 
        !contactNumber.isEmpty && contactNumber.count == 6 && contactNumber.allSatisfy({ $0.isNumber }) && 
               !licenseNumber.isEmpty
    }
    
    private func saveHospitalInfo() {
        // Save hospital information to your data model
        // Example: DataController.shared.saveHospitalInfo(name: hospitalName, location: location, pinCode: pinCode, licenseNumber: licenseNumber)
    }
}
