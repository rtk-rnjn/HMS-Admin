//
//  Hospital.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 21/03/25.
//

import Foundation
import MapKit

struct Hospital: Codable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case address
        case contact
        case departments
        case latitude
        case longitude
        case specializations
        case adminId = "admin_id"
        case announcements
        case hospitalLicenceNumber = "hospital_licence_number"
    }

    var id: String = UUID().uuidString
    var name: String
    var address: String?
    var contact: String?
    var departments: [String] = []
    var latitude: Double?
    var longitude: Double?
    var specializations: [String] = []
    var adminId: String
    var announcements: [Announcement] = []
    var hospitalLicenceNumber: String
}

struct Announcement: Codable, Equatable, Identifiable {
    enum CodingKeys: String, CodingKey {
        case title
        case body
        case createdAt = "created_at"
        case broadcastTo = "broadcast_to"
        case category
    }

    var id: UUID = .init()

    var title: String
    var body: String
    var createdAt: Date = .init()
    var broadcastTo: [String] = []
    var category: AnnouncementCategory = .general
}

enum AnnouncementCategory: String, Codable, CaseIterable {
    case general = "General"
    case emergency = "Emergency"
    case appointment = "Appointment"
    case holiday = "Holiday"
}
