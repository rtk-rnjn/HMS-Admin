import SwiftUI
import Combine

// Central store for managing doctor data across the app
class DoctorStore: ObservableObject {
    @Published var doctors: [Staff] = []
    
    // Singleton pattern to access store from anywhere
    static let shared = DoctorStore()
    
    private init() {
        loadInitialDoctors()
    }
    
    func addDoctor(_ doctor: Staff) {
        doctors.append(doctor)
    }
    
    func updateDoctor(_ doctor: Staff) {
        if let index = doctors.firstIndex(where: { $0.id == doctor.id }) {
            doctors[index] = doctor
        }
    }
    
    func deleteDoctor(id: String) {
        doctors.removeAll { $0.id == id }
    }
    
    // Load initial sample data
    private func loadInitialDoctors() {
        // Sample data
        doctors = [
            Staff(
                id: UUID().uuidString,
                firstName: "Sarah",
                lastName: "Wilson",
                emailAddress: "doctor@hospital.com",
                dateOfBirth: Date(),
                password: "password",
                contactNumber: "+1 (555) 000-0000",
                specializations: ["Cardiology"],
                department: "Cardiology Department",
                onLeave: false,
                consultationFee: 200,
                unavailabilityPeriods: [],
                joiningDate: Date(),
                licenseId: "ML123456",
                yearOfExperience: 5,
                role: .doctor,
                hospitalId: "hospital123"
            ),
            Staff(
                id: UUID().uuidString,
                firstName: "James",
                lastName: "Miller",
                emailAddress: "james.miller@hospital.com",
                dateOfBirth: Date(),
                password: "password",
                contactNumber: "5557894562",
                specializations: ["Neurology"],
                department: "Neurology Department",
                onLeave: false,
                consultationFee: 250,
                unavailabilityPeriods: [],
                joiningDate: Date(),
                licenseId: "ML654321",
                yearOfExperience: 8,
                role: .doctor,
                hospitalId: "hospital123"
            ),
            Staff(
                id: UUID().uuidString,
                firstName: "Emily",
                lastName: "Johnson",
                emailAddress: "emily.johnson@hospital.com",
                dateOfBirth: Date(),
                password: "password",
                contactNumber: "5552134567",
                specializations: ["Pediatrics"],
                department: "Pediatrics Department",
                onLeave: true,
                consultationFee: 180,
                unavailabilityPeriods: [],
                joiningDate: Date(),
                licenseId: "ML789456",
                yearOfExperience: 6,
                role: .doctor,
                hospitalId: "hospital123"
            )
        ]
    }
} 