import SwiftUI

struct PendingLeaveRequestsView: View {

    // MARK: Internal

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
                                isProcessing: processingRequests.contains(request.id),
                                cardWidth: cardWidth,
                                cardHeight: cardHeight
                            )
                        }
                    }
                    .padding(.leading, 0)
                    .padding(.trailing)
                }
            }
        }
    }

    // MARK: Private

    // Define a consistent card size
    private let cardWidth: CGFloat = 300
    private let cardHeight: CGFloat = 180

}

struct LeaveRequestCard: View {

    // MARK: Internal

    let request: LeaveRequest
    let onApprove: (LeaveRequest) -> Void
    let onReject: (LeaveRequest) -> Void
    let isProcessing: Bool

    // Add parameters for card size
    let cardWidth: CGFloat
    let cardHeight: CGFloat

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
                    Text(request.doctor?.fullName ?? "Unknown Doctor")
                        .font(.headline)
                        .lineLimit(1)
                    Text(request.doctor?.department ?? "Unknown Department")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }

                Spacer()

            }
            .padding(.bottom, 12)

            VStack(alignment: .leading, spacing: 8) {
                LeaveDetailRow(icon: "text.alignleft", label: "Reason", value: request.reason, maxLines: 2)
            }
            .padding(.vertical, 12)

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
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Text("Reject")
                        }
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(Color("errorBlue"))
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
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        // Apply the consistent size provided as parameters
        .frame(width: cardWidth, height: cardHeight)
        .opacity(isProcessing ? 0.7 : 1.0)
    }

    // MARK: Private

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }

}

struct LeaveDetailRow: View {
    let icon: String
    let label: String
    let value: String
    var maxLines: Int?

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

    // MARK: Internal

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
                        Text(request.doctor?.fullName ?? "Unknown Doctor")
                            .font(.headline)
                        Text(request.doctor?.department ?? "Unknown Department")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                // Leave details
                VStack(alignment: .leading, spacing: 8) {
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
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(Color("errorBlue"))
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
                        .background(Color("successBlue"))
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

    // MARK: Private

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }


}
