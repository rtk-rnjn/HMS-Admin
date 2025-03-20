//
//  Admin.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import Foundation

enum Role: String, Codable {
    case admin
    case doctor
}

struct Admin: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case emailAddress = "email_address"
        case password = "password"
        case role = "role"
    }

    var id: String = UUID().uuidString
    var emailAddress: String
    var password: String
    var role: Role = .admin
}
