//
//  DoctorListView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import SwiftUI

struct DoctorListView: View {

    // MARK: Internal

    var delegate: DoctorsHostingController?

    var totalDoctors: [Staff] = []

    // This will be set from the hosting controller
    var searchQuery: String = ""

    var body: some View {

        ZStack {
            // Background color that covers the entire screen
            Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            // Main content
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    HStack(spacing: 12) {
                        DoctorStatCard(
                            title: "Total Doctors",
                            value: "\(totalDoctors.count)",
                            icon: "stethoscope",
                            color: Color("iconBlue")
                        )

                        DoctorStatCard(
                            title: "Active",
                            value: "\(activeDoctors.count)",
                            icon: "checkmark.circle",
                            color: Color("iconBlue")
                        )

                        DoctorStatCard(
                            title: "On Leave",
                            value: "\(onLeaveDoctors.count)",
                            icon: "moon.fill",
                            color: Color("iconBlue")
                        )
                    }
                    .padding(.horizontal)
                    VStack(spacing: 16) {
                        if totalDoctors.isEmpty {
                            VStack(spacing: 20) {
                                Image(systemName: "person.2.slash")
                                    .font(.largeTitle)
                                    .foregroundColor(Color("iconBlue"))
                                Text("No Doctors Added")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                Text("Add your first doctor to get started")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 100)
                        } else {
                            ForEach(filteredDoctors, id: \.id) { doctor in
                                DoctorCard(doctor: doctor)
                            }

                            if filteredDoctors.isEmpty && !searchQuery.isEmpty {
                                Text("No doctors found matching '\(searchQuery)'")
                                    .foregroundColor(.secondary)
                                    .padding()
                            }
                        }

                        Color.clear.frame(height: 20)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    // MARK: Private

    @State private var showingAddDoctorView = false

    private var activeDoctors: [Staff] {
        return totalDoctors.filter { !$0.onLeave }
    }

    private var onLeaveDoctors: [Staff] {
        return totalDoctors.filter { $0.onLeave }
    }

    private var filteredDoctors: [Staff] {
        guard !searchQuery.isEmpty else {
            return totalDoctors
        }

        let query = searchQuery.lowercased()
        return totalDoctors.filter { doctor in
            doctor.fullName.lowercased().contains(query) ||
            doctor.specialization.lowercased().contains(query) ||
            doctor.department.lowercased().contains(query)
        }
    }

}

struct DoctorCard: View {
    let doctor: Staff

    var body: some View {
        NavigationLink(destination: DoctorProfileView(doctor: doctor)) {
            HStack(spacing: 12) {
                // Profile image
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color("iconBlue"))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    // Name
                    Text(doctor.fullName)
                        .font(.body)
                        .foregroundColor(.primary)

                    // Department
                    Text(doctor.department)
                        .font(.subheadline)

                        .foregroundColor(.secondary)

                    // Specialization
                    Text(doctor.specialization)
                        .font(.subheadline)

                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Status indicator
                Circle()
                    .fill(doctor.onLeave ? Color.orange : Color.green)
                    .frame(width: 10, height: 10)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
        }
    }
}
