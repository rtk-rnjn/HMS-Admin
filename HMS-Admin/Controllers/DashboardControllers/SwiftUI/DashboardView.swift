//
//  DashboardView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

struct DashboardView: View {
    weak var delegate: DashboardHostingController?

    @State private var searchText = ""
    @State private var showNotifications = false
    @State private var selectedTimeRange = "Today"
    @State private var showProfile = false
    @State private var leaveRequests: [LeaveRequest] = [
        // Sample leave request data
        LeaveRequest(
            doctorId: "1",
            doctorName: "Dr. John Smith",
            department: "Cardiology",
            startDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
            reason: "Annual family vacation",
            status: .pending,
            createdAt: Date()
        ),
        LeaveRequest(
            doctorId: "2",
            doctorName: "Dr. Sarah Johnson",
            department: "Pediatrics",
            startDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 4, to: Date()) ?? Date(),
            reason: "Medical conference attendance",
            status: .pending,
            createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date()
        ),
        LeaveRequest(
            doctorId: "3",
            doctorName: "Dr. Michael Chen",
            department: "Neurology",
            startDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 9, to: Date()) ?? Date(),
            reason: "Personal emergency",
            status: .pending,
            createdAt: Calendar.current.date(byAdding: .hour, value: -5, to: Date()) ?? Date()
        )
    ]

    var activeDoctorCount: Int = 0
    var patientCount: Int = 0

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
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        QuickStatCard(
                            title: "Active Doctors",
                            value: "\(activeDoctorCount)",
                            icon: "stethoscope",
                            color: .blue,
                            trend: "+5%"
                        )

                        QuickStatCard(
                            title: "Today's Patients",
                            value: "\(patientCount)",
                            icon: "person.2.fill",
                            color: .green,
                            trend: "+12%"
                        )
                    }
                    .padding(.horizontal)
                }

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    QuickActionButton(
                        title: "Add Doctor",
                        subtitle: "New registration",
                        icon: "person.badge.plus",
                        color: .blue,
                        action: {
                            delegate?.performSegue(withIdentifier: "segueShowAddDoctorHostingController", sender: nil)
                        }
                    )

                    QuickActionButton(
                        title: "Announcement",
                        subtitle: "New message",
                        icon: "megaphone.fill",
                        color: .purple,
                        action: {
                            delegate?.performSegue(withIdentifier: "segueShowCreateAnnouncementHostingController", sender: nil)
                        }
                    )

                    QuickActionButton(
                        title: "Reports",
                        subtitle: "View analytics",
                        icon: "chart.bar.fill",
                        color: .orange
                    )
                }
                .padding(.horizontal)

                // Leave Requests Section
                PendingLeaveRequestsView(
                    leaveRequests: leaveRequests.filter { $0.status == .pending },
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

                        Button("See All") {
                            // Handle see all
                        }
                        .foregroundColor(.blue)
                    }

                    ForEach(1...4, id: \.self) { _ in
                        ActivityRow()
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
                    self.leaveRequests = requests
                }
            }
        }
    }
    
    private func handleLeaveApproval(_ request: LeaveRequest) {
        // Add request to processing set
        processingRequests.insert(request.id)
        
        // Optimistically update local state
        if let index = leaveRequests.firstIndex(where: { $0.id == request.id }) {
            var updatedRequest = request
            updatedRequest.status = .approved
            leaveRequests[index] = updatedRequest
        }
        
        Task {
            // Make API call
            let success = await DataController.shared.approveLeaveRequest(request)
            
            DispatchQueue.main.async {
                // Remove from processing set
                processingRequests.remove(request.id)
                
                if !success {
                    // Revert local state if API call failed
                    if let index = leaveRequests.firstIndex(where: { $0.id == request.id }) {
                        var revertedRequest = request
                        revertedRequest.status = .pending
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
    
    private func handleLeaveRejection(_ request: LeaveRequest) {
        // Add request to processing set
        processingRequests.insert(request.id)
        
        // Optimistically update local state
        if let index = leaveRequests.firstIndex(where: { $0.id == request.id }) {
            var updatedRequest = request
            updatedRequest.status = .rejected
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
                        var revertedRequest = request
                        revertedRequest.status = .pending
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
    let trend: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)

                Spacer()

                Text(trend)
                    .font(.caption)
                    .foregroundColor(trend.hasPrefix("+") ? .green : .red)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        (trend.hasPrefix("+") ? Color.green : Color.red)
                            .opacity(0.1)
                    )
                    .cornerRadius(8)
            }

            Text(value)
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 180)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
    }
}

struct ActivityRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "stethoscope")
                        .foregroundColor(.blue)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("Dr. Smith added a new patient")
                    .font(.subheadline)
                    .fontWeight(.medium)

                Text("2 hours ago")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
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
                            .foregroundColor(color)
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
