//
//  DataController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 20/03/25.
//

import Foundation

class DataController {
    @MainActor static let shared: DataController = .init()

    var doctors: [Staff] = []

    func addDoctor(_ doctor: Staff) async {
        doctors.append(doctor)
    }

    func removeDoctor(_ doctor: Staff) async {
        doctors.removeAll { $0.id == doctor.id }
    }

    func updateDoctor(_ doctor: Staff) async {
        guard let index = doctors.firstIndex(where: { $0.id == doctor.id }) else {
            return
        }
        doctors[index] = doctor
    }

    func fetchDoctors() async -> [Staff] {
        return doctors
    }
}
