//
//  CreateAnnouncementView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 29/03/25.
//

import SwiftUI

struct CreateAnnouncementView: View {
    @State private var title: String = ""
    @State private var message: String = ""
    @State private var category: AnnouncementCategory = .general
    @State private var broadcastTo: [String] = []
    @Environment(\.dismiss) private var dismiss

    // Haptic feedback generators
    @State private var impactFeedback: UIImpactFeedbackGenerator = .init(style: .medium)
    @State private var notificationFeedback: UINotificationFeedbackGenerator = .init()
    @State private var selectionFeedback: UISelectionFeedbackGenerator = .init()

    var onSave: ((Announcement) -> Void)?

    let recipientOptions = ["Doctor", "Patient"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                        .onChange(of: title) { _ in
                            // Light haptic when typing title
                            impactFeedback.prepare()
                            impactFeedback.impactOccurred(intensity: 0.4)
                        }
                }

                Section(header: Text("Body")) {
                    TextEditor(text: $message)
                        .frame(minHeight: 100)
                        .onChange(of: message) { _ in
                            // Very light haptic when typing message
                            impactFeedback.prepare()
                            impactFeedback.impactOccurred(intensity: 0.3)
                        }
                }

                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $category) {
                        ForEach(AnnouncementCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: category) { _ in
                        // Selection haptic when changing category
                        selectionFeedback.prepare()
                        selectionFeedback.selectionChanged()
                    }
                }

                Section(header: Text("Broadcast To")) {
                    ForEach(recipientOptions, id: \.self) { recipient in
                        Toggle(recipient, isOn: Binding(
                            get: { broadcastTo.contains(recipient) },
                            set: { isSelected in
                                // Medium impact when toggling recipients
                                impactFeedback.prepare()
                                impactFeedback.impactOccurred(intensity: 0.7)

                                if isSelected {
                                    broadcastTo.append(recipient)
                                } else {
                                    broadcastTo.removeAll { $0 == recipient }
                                }
                            }
                        ))
                    }
                }
            }
            .navigationTitle("Create Announcement")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        // Error haptic when canceling
                        notificationFeedback.prepare()
                        notificationFeedback.notificationOccurred(.error)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Send") {
                        // Success haptic when sending
                        notificationFeedback.prepare()
                        notificationFeedback.notificationOccurred(.success)

                        let newAnnouncement = Announcement(title: title, body: message, broadcastTo: broadcastTo, category: category)
                        onSave?(newAnnouncement)
                        dismiss()
                    }
                    .disabled(title.isEmpty || message.isEmpty)
                }
            }
        }
    }
}
