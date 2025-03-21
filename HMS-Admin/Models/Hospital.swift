//
//  Hospital.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 21/03/25.
//

import Foundation

struct Hospital: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case address
        case contact
        case departments
        case specializations
        case adminId = "admin_id"
        case announcements
    }

    var id: String = UUID().uuidString
    var name: String
    var address: String?
    var contact: String?
    var departments: [String] = []
    var specializations: [String] = []
    var adminId: String
    var announcements: [Announcement] = []
}

struct Announcement: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case title
        case message
        case createdAt = "created_at"
    }

    var title: String
    var message: String
    var createdAt: Date
}
