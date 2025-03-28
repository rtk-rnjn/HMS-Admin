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

    var onSave: ((Announcement) -> Void)?

    let recipientOptions = ["Doctor", "Patient"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }

                Section(header: Text("Body")) {
                    TextEditor(text: $message)
                        .frame(minHeight: 100)
                }

                Section(header: Text("Category")) {
                    Picker("Select Category", selection: $category) {
                        ForEach(AnnouncementCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }

                Section(header: Text("Broadcast To")) {
                    ForEach(recipientOptions, id: \.self) { recipient in
                        Toggle(recipient, isOn: Binding(
                            get: { broadcastTo.contains(recipient) },
                            set: { isSelected in
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
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
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
