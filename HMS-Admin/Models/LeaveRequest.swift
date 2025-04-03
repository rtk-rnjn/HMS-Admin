import Foundation


struct LeaveRequest: Codable, Identifiable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case doctorId = "doctor_id"
        case reason
        case dates
        case approved
        case createdAt = "created_at"
    }

    var id: String = UUID().uuidString
    var doctorId: String
    var dates: [Date]
    var reason: String
    var approved: Bool
    var createdAt: Date = .init()

    var doctor: Staff?
}
