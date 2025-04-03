//
//  AnnouncementView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct AnnouncementView: View {

    // MARK: Internal

    var announcements: [Announcement] = []

    var body: some View {
        List {
            ForEach(groupedAnnouncements.keys.sorted(by: >), id: \.self) { date in
                Section(header: Text(formatSectionDate(date))) {
                    ForEach(groupedAnnouncements[date] ?? [], id: \.title) { announcement in
                        HStack(spacing: 12) {
                            categoryIcon(for: announcement.category)
                                .foregroundColor(categoryColor(for: announcement.category))
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(announcement.title)
                                    .font(.headline)
                                Text(announcement.body)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(formatTime(announcement.createdAt))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(4)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    
    private var groupedAnnouncements: [Date: [Announcement]] {
        let calendar = Calendar.current
        return Dictionary(grouping: announcements) { announcement in
            calendar.startOfDay(for: announcement.createdAt)
        }
    }
    
    private func formatSectionDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE" // Full weekday name
            return formatter.string(from: date)
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy"
            return formatter.string(from: date)
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }

    private func categoryIcon(for category: AnnouncementCategory) -> Image {
        switch category {
        case .general: return Image(systemName: "megaphone.fill")
        case .emergency: return Image(systemName: "exclamationmark.triangle.fill")
        case .appointment: return Image(systemName: "calendar.badge.clock")
        case .holiday: return Image(systemName: "gift.fill")
        }
    }

    private func categoryColor(for category: AnnouncementCategory) -> Color {
        switch category {
        case .general: return .blue
        case .emergency: return .red
        case .appointment: return .green
        case .holiday: return .orange
        }
    }
}
