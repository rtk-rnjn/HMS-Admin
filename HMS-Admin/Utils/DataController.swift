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

    let queue: DispatchQueue = .init(label: "Queue")

    var hospital: Hospital? {
        didSet {
            guard let hospital else { return }
            Task {
                await updateHospital(hospital)
            }
        }
    }

    func updateHospital(_ newHospital: Hospital) async -> Bool {
        guard let body = newHospital.toData() else { return false }
        let response: UpdateResponse? = await MiddlewareManager.shared.patch(url: "/admin/hospital", body: body)
        return response?.success ?? false
    }

    func fetchHospital() async -> Hospital? {
        guard let adminId = UserDefaults.standard.string(forKey: "adminId") else { return nil }

        let hospital: Hospital? = await MiddlewareManager.shared.get(url: "/admin/hospital/\(adminId)")
        self.hospital = hospital
        return hospital

    }

    func fetchAdmin(email: String, password: String) async -> Admin? {
        let admin: Admin? = await MiddlewareManager.shared.get(url: "/user/fetch", queryParameters: ["email_address": email, "password": password])
        if admin?.role == .admin {
            UserDefaults.standard.set(admin?.id, forKey: "adminId")
        }
        return admin?.role == .admin ? admin : nil
    }

    func updateAdmin(_ newAdmin: Admin) async -> Bool {
        guard let body = newAdmin.toData() else { return false }
        let response: UpdateResponse? = await MiddlewareManager.shared.put(url: "/user/update/\(newAdmin.id)", body: body)
        return response?.success ?? false
    }
}

extension DataController {
    func fetchDoctors() async -> [Staff] {
        _ = await fetchHospital()
        return await MiddlewareManager.shared.get(url: "/admin/staffs/\(hospital?.id ?? "")") ?? []
    }

    func createDoctor(_ doctor: Staff) async -> Bool {
        guard let body = doctor.toData() else { return false }
        let response: UpdateResponse? = await MiddlewareManager.shared.post(url: "/admin/staff", body: body)
        return response?.success ?? false
    }

    func updateDoctor(_ doctor: Staff) async -> Bool {
        guard let body = doctor.toData() else { return false }
        let response: UpdateResponse? = await MiddlewareManager.shared.put(url: "/admin/staff/\(doctor.id)", body: body)
        return response?.success ?? false
    }
}
