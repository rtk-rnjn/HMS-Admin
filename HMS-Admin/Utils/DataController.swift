//
//  DataController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 20/03/25.
//

import Foundation

struct UpdateResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case success
        case modifiedCount = "modified_count"
        case detail
    }

    let success: Bool
    let modifiedCount: Int
    let detail: String?
}

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

    func fetchDoctors(limit: Int = 0) async -> [Staff] {
        return doctors
    }

    func fetchAdmin(email: String, password: String) async -> Admin? {
        return await MiddlewareManager.shared.get(url: "/user/fetch", queryParameters: ["email_address": email, "password": password])
    }

    func updateAdmin(_ newAdmin: Admin) async -> Bool {
        guard let body = newAdmin.toData() else { return false }
        let response: UpdateResponse? = await MiddlewareManager.shared.put(url: "/user/update/\(newAdmin.id)", body: body)
        return response?.success ?? false
    }
}
