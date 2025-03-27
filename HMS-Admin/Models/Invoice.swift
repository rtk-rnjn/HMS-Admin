//
//  Invoice.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import Foundation

struct Invoice: Codable, Identifiable {
    var id: UUID = .init()

    var patientName: String
    var amount: Double
    var status: String

    var date: Date = .init()
}
