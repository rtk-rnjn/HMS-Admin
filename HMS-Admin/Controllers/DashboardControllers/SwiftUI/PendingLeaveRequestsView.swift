import SwiftUI

struct PendingLeaveRequestsView: View {
    var leaveRequests: [LeaveRequest]
    var onApprove: (LeaveRequest) -> Void
    var onReject: (LeaveRequest) -> Void
    var processingRequests: Set<String> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Leave Requests")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                if !leaveRequests.isEmpty {
                    NavigationLink("See All") {
                        LeaveRequestListView(
                            leaveRequests: leaveRequests,
                            onApprove: onApprove,
                            onReject: onReject,
                            processingRequests: processingRequests
                        )
                    }
                    .foregroundColor(.blue)
                }
            }
            
            if leaveRequests.isEmpty {
                HStack {
                    Spacer()
                    Text("No pending leave requests")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.vertical, 20)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(leaveRequests.prefix(3)) { request in
                            LeaveRequestCard(
                                request: request,
                                onApprove: onApprove,
                                onReject: onReject,
                                isProcessing: processingRequests.contains(request.id)
                            )
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

struct LeaveRequestCard: View {
    let request: LeaveRequest
    let onApprove: (LeaveRequest) -> Void
    let onReject: (LeaveRequest) -> Void
    let isProcessing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Doctor info
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(Color("iconBlue"))
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(request.doctorName)
                        .font(.headline)
                        .lineLimit(1)
                    Text(request.department)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Leave duration badge
                Text("\(calculateLeaveDays()) days")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
            .padding(.bottom, 12)
            
            Divider()
            
            // Leave details
            VStack(alignment: .leading, spacing: 8) {
                LeaveDetailRow(icon: "calendar", label: "From", value: formatDate(request.startDate))
                LeaveDetailRow(icon: "calendar", label: "To", value: formatDate(request.endDate))
                LeaveDetailRow(icon: "text.alignleft", label: "Reason", value: request.reason, maxLines: 2)
            }
            .padding(.vertical, 12)
            
            Divider()
            
            // Action buttons
            HStack(spacing: 12) {
                Button(action: { 
                    if !isProcessing {
                        onReject(request)
                    }
                }) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                .scaleEffect(0.8)
                        } else {
                            Text("Reject")
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }
                .disabled(isProcessing)
                
                Button(action: { 
                    if !isProcessing {
                        onApprove(request)
                    }
                }) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Text("Approve")
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(Color("successBlue"))
                    .cornerRadius(8)
                }
                .disabled(isProcessing)
            }
            .padding(.top, 12)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .frame(width: 300, height: 280)
        .opacity(isProcessing ? 0.7 : 1.0)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func calculateLeaveDays() -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: request.startDate, to: request.endDate)
        return max(1, (components.day ?? 0) + 1) // Add 1 to include both start and end dates
    }
}

struct LeaveDetailRow: View {
    let icon: String
    let label: String
    let value: String
    var maxLines: Int? = nil
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color("iconBlue"))
                .frame(width: 16)
            
            Text(label)
                .foregroundColor(.gray)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .lineLimit(maxLines)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct LeaveRequestListView: View {
    var leaveRequests: [LeaveRequest]
    var onApprove: (LeaveRequest) -> Void
    var onReject: (LeaveRequest) -> Void
    var processingRequests: Set<String> = []
    
    var body: some View {
        List(leaveRequests) { request in
            VStack(alignment: .leading, spacing: 12) {
                // Doctor info
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(Color("iconBlue"))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(request.doctorName)
                            .font(.headline)
                        Text(request.department)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        // Leave duration badge
                        Text("\(calculateLeaveDays(for: request)) days")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text(formatDate(request.createdAt))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // Leave details
                VStack(alignment: .leading, spacing: 8) {
                    LeaveDetailRow(icon: "calendar", label: "From", value: formatDate(request.startDate))
                    LeaveDetailRow(icon: "calendar", label: "To", value: formatDate(request.endDate))
                    LeaveDetailRow(icon: "text.alignleft", label: "Reason", value: request.reason)
                }
                
                // Action buttons
                HStack(spacing: 12) {
                    Button(action: { 
                        if !processingRequests.contains(request.id) {
                            onReject(request)
                        }
                    }) {
                        HStack {
                            if processingRequests.contains(request.id) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .red))
                                    .scaleEffect(0.8)
                            } else {
                                Text("Reject")
                            }
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color("disableBlue"))
                        .cornerRadius(8)
                    }
                    .disabled(processingRequests.contains(request.id))
                    
                    Button(action: { 
                        if !processingRequests.contains(request.id) {
                            onApprove(request)
                        }
                    }) {
                        HStack {
                            if processingRequests.contains(request.id) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Text("Approve")
                            }
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                    }
                    .disabled(processingRequests.contains(request.id))
                }
            }
            .padding(.vertical, 8)
            .opacity(processingRequests.contains(request.id) ? 0.7 : 1.0)
        }
        .navigationTitle("Leave Requests")
        .listStyle(InsetGroupedListStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func calculateLeaveDays(for request: LeaveRequest) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: request.startDate, to: request.endDate)
        return max(1, (components.day ?? 0) + 1) // Add 1 to include both start and end dates
    }
} 
