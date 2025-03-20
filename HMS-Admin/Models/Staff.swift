//
//  Staff.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 20/03/25.
//

import Foundation

struct UnavailablePeriod: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
    }

    let startDate: Date
    let endDate: Date
}

struct Staff: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case emailAddress = "email_address"
        case password = "password"
        case contactNumber = "contact_number"
        case specializations = "specializations"
        case department = "department"
        case onLeave = "on_leave"
        case unavailabilityPeriods = "unavailability_periods"
        case licenseId = "license_id"
        case role = "role"
    }

    let id: String = UUID().uuidString
    let firstName: String
    let lastName: String? = nil

    var fullName: String {
        let lastName = self.lastName ?? ""
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

    let emailAddress: String
    let password: String
    let contactNumber: String
    let specializations: [String]
    let department: String
    let onLeave: Bool = false

    let unavailabilityPeriods: [UnavailablePeriod] = []
    let licenseId: String
    let role: Role = .doctor
}
