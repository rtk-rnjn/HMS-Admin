//
//  DashboardView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct DashboardView: View {
    weak var delegate: DashboardHostingController?

    var logs: [Log] = []
    @State private var searchText = ""
    @State private var showNotifications = false
    @State private var selectedTimeRange = "Today"
    @State private var showProfile = false
    @State private var leaveRequests: [LeaveRequest] = []

    var activeDoctorCount: Int = 0
    var patientCount: Int = 0
   // var doctorTrend: String = "+0%"
   // var patientTrend: String = "+0%"

    let timeRanges = ["Today", "Week", "Month"]

    // Sample data for the chart
    let patientData: [(String, Int)] = [
        ("Mon", 24), ("Tue", 30), ("Wed", 28),
        ("Thu", 32), ("Fri", 25), ("Sat", 20),
        ("Sun", 22)
    ]

    @State private var processingRequests: Set<String> = [] // Track requests being processed

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Stats Cards - Fixed, not scrollable
                HStack(spacing: 16) {
                    QuickStatCard(
                        title: "Active Doctors",
                        value: "\(activeDoctorCount)",
                        icon: "stethoscope",
                        color: Color("iconBlue")
              //          trend: doctorTrend
                    )
                    .frame(maxWidth: .infinity)

                    QuickStatCard(
                        title: "Today's Patients",
                        value: "\(patientCount)",
                        icon: "person.2.fill",
                        color: Color("iconBlue")
                 //       trend: patientTrend
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    QuickActionButton(
                        title: "Add Doctor",
                        subtitle: "New registration",
                        icon: "person.badge.plus",
                        color: Color("iconBlue"),
                        action: {
                            delegate?.performSegue(withIdentifier: "segueShowAddDoctorHostingController", sender: nil)
                        }
                    )

                    QuickActionButton(
                        title: "Announcement",
                        subtitle: "New message",
                        icon: "megaphone.fill",
                        color: Color("iconBlue"),
                        action: {
                            delegate?.performSegue(withIdentifier: "segueShowCreateAnnouncementHostingController", sender: nil)
                        }
                    )

                    QuickActionButton(
                        title: "Reports",
                        subtitle: "View analytics",
                        icon: "chart.bar.fill",
                        color: Color("iconBlue"),
                        action: {
                            delegate?.showReports()
                        }
                    )
                }
                .padding(.horizontal)

                // Leave Requests Section
                PendingLeaveRequestsView(
                    leaveRequests: leaveRequests.filter { !$0.approved },
                    onApprove: handleLeaveApproval,
                    onReject: handleLeaveRejection,
                    processingRequests: processingRequests
                )
                .padding(.horizontal)

                // Recent Activity
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Recent Activity")
                            .font(.title3)
                            .fontWeight(.bold)

                        Spacer()

                        NavigationLink("See All") {
                            AllActivitiesView(logs: logs)
                        }
                        .foregroundColor(.blue)
                    }

                    ForEach(Array(logs.prefix(5)), id: \.self) { log in
                        ActivityRow(log: log)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Dashboard")
        .onAppear {
            fetchLeaveRequests()
        }
    }

    private func fetchLeaveRequests() {
        Task {
            if let requests = await DataController.shared.fetchLeaveRequests() {
                DispatchQueue.main.async {
                    leaveRequests = requests
                }
            }
        }
    }

    private func handleLeaveApproval(_ request: LeaveRequest) {
        // Add request to processing set
//        processingRequests.insert(request.id)
//
//        // Optimistically update local state
//        if let index = leaveRequests.firstIndex(where: { $0.id == request.id }) {
//            let updatedRequest = request
//            leaveRequests[index] = updatedRequest
//        }
//
//        Task {
//            // Make API call
//            let success = await DataController.shared.approveLeaveRequest(request)
//
//            DispatchQueue.main.async {
//                // Remove from processing set
//                processingRequests.remove(request.id)
//
//                if !success {
//                    // Revert local state if API call failed
//                    if let index = leaveRequests.firstIndex(where: { $0.id == request.id }) {
//                        let revertedRequest = request
//                        leaveRequests[index] = revertedRequest
//                    }
//                    // Show error message
//                    // Note: You might want to add an @State property for showing alerts
//                }
//
//                // Refresh the list to get the latest state
//                fetchLeaveRequests()
//            }
//        }
        Task {
            await DataController.shared.approveLeaveRequest(request)
        }
    }

    private func handleLeaveRejection(_ request: LeaveRequest) {
        // Add request to processing set
        processingRequests.insert(request.id)

        // Optimistically update local state
        if let index = leaveRequests.firstIndex(where: { $0.id == request.id }) {
            let updatedRequest = request
            leaveRequests[index] = updatedRequest
        }

        Task {
            // Make API call
            let success = await DataController.shared.rejectLeaveRequest(request)

            DispatchQueue.main.async {
                // Remove from processing set
                processingRequests.remove(request.id)

                if !success {
                    // Revert local state if API call failed
                    if let index = leaveRequests.firstIndex(where: { $0.id == request.id }) {
                        let revertedRequest = request
                        leaveRequests[index] = revertedRequest
                    }
                    // Show error message
                    // Note: You might want to add an @State property for showing alerts
                }

                // Refresh the list to get the latest state
                fetchLeaveRequests()
            }
        }
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

  //  let trend: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)

                Spacer()

            }

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
    }
}

struct ActivityRow: View {
    var log: Log

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "stethoscope")
                        .foregroundColor(Color("iconBlue"))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(log.message)
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text(log.createdAt.humanReadableString())
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct QuickActionButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    var action: (() -> Void)?

    var body: some View {
        Button(action: {
            action?()
        }) {
            VStack(spacing: 8) {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(Color("iconBlue"))
                    )

                VStack(spacing: 2) {
                    Text(title)
                        .font(.callout)
                        .fontWeight(.medium)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}
