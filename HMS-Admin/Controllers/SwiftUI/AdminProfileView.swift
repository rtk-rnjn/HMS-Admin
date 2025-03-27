//
//  AdminProfileView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct AdminProfileView: View {
    var body: some View {
        List {
            // Profile Header Section
            Section {
                HStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .foregroundColor(.blue)
                        .background(Circle().fill(Color.blue.opacity(0.1)))

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Admin")
                            .font(.headline)
                        Text("Administrator")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 8)
            }

            // Contact Information Section
            Section("Contact Information") {
                InfoRow(icon: "envelope.fill", label: "Email", value: "admin@hms.local")
                InfoRow(icon: "building.2.fill", label: "Department", value: "Administrator")
            }

            Section {
                Button(action: {
                    dismiss()
                }) {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
