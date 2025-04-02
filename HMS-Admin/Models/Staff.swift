//
//  Staff.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 20/03/25.
//

import Foundation

enum Gender: String, Codable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

struct UnavailablePeriod: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case startDate = "start_date"
        case endDate = "end_date"
    }

    let startDate: Date
    let endDate: Date
}

struct WorkingHours: Codable, Equatable {
    var startTime: Date
    var endTime: Date
}

struct Staff: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case gender
        case emailAddress = "email_address"
        case password = "password"
        case contactNumber = "contact_number"
        case dateOfBirth = "date_of_birth"
        case specialization = "specialization"
        case department = "department"
        case onLeave = "on_leave"
        case consultationFee = "consultation_fee"
        case unavailabilityPeriods = "unavailability_periods"
        case joiningDate = "joining_date"
        case licenseId = "license_id"
        case yearOfExperience = "year_of_experience"
        case role = "role"
        case hospitalId = "hospital_id"
        case workingHours = "working_hours"
    }

    var id: String = UUID().uuidString
    var firstName: String
    var lastName: String?

    var gender: Gender = .other

    var emailAddress: String
    var dateOfBirth: Date
    var password: String
    var contactNumber: String
    var specialization: String
    var department: String
    var onLeave: Bool = false
    var consultationFee: Int = 0

    var unavailabilityPeriods: [UnavailablePeriod] = []
    var joiningDate: Date = .init()
    var licenseId: String
    var yearOfExperience: Int = 0
    var role: Role = .doctor

    var hospitalId: String = ""

    var shiftStartTime: Int = 9
    var shiftEndTime: Int = 17
    
    var workingHours: WorkingHours?

    var fullName: String {
        let lastName = lastName ?? ""
        return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

}
