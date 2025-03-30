//
//  AppointmentStatus.swift
//  HMS-Admin
//
//  Created by Dhruvi on 30/03/25.
//

import Foundation

enum AppointmentStatus: String, Codable {
    case confirmed = "Confirmed"
}

struct Appointment: Codable, Identifiable, Hashable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case patientId = "patient_id"
        case doctorId = "doctor_id"
        case startDate = "start_time"
        case endDate = "end_time"
        case status
        case prescription
        case notes
        case reference
    }

    var id: String = UUID().uuidString

    var patientId: String
    var doctorId: String

    var startDate: Date
    var endDate: Date
    var status: AppointmentStatus = .confirmed

    var prescription: String?
    var notes: String?

    var reference: String?
    var createdAt: Date = .init()

}
