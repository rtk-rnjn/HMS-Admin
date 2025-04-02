import Foundation

struct Review: Codable, Identifiable {
    let id: String
    let patientName: String
    let rating: Double
    let comment: String
    let date: Date
    
    init(id: String = UUID().uuidString,
         patientName: String,
         rating: Double,
         comment: String,
         date: Date = Date()) {
        self.id = id
        self.patientName = patientName
        self.rating = rating
        self.comment = comment
        self.date = date
    }
} 