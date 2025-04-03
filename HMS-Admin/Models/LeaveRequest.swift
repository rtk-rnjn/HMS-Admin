import Foundation

enum LeaveStatus: String, Codable {
    case pending = "Pending"
    case approved = "Approved"
    case rejected = "Rejected"
}

struct LeaveRequest: Codable, Identifiable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case doctorId = "doctor_id"
        case startDate = "start_date"
        case endDate = "end_date"
        case reason
        case status
        case createdAt = "created_at"
        case doctorName = "doctor_name"
        case department
    }

    var id: String = UUID().uuidString
    var doctorId: String
    var doctorName: String
    var department: String
    var startDate: Date
    var endDate: Date
    var reason: String
    var status: LeaveStatus = .pending
    var createdAt: Date = .init()
}
