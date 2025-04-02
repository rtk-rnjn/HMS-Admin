//
//  DoctorProfileView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import SwiftUI

struct DoctorProfileView: View {
    let doctor: Staff
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var sizeClass
    @State private var showingDeleteConfirmation = false
    @State private var reviews: [Review] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sizeClass == .regular ? 140 : 120, height: sizeClass == .regular ? 140 : 120)
                        .foregroundColor(Color(.systemGray4))
                        .clipShape(Circle())

                    // Name with "Dr." prefix
                    Text("Dr. \(doctor.fullName)")
                        .font(.system(size: 22, weight: .bold))

                    // Redesigned smaller status badge
                    Text(doctor.onLeave ? "Inactive" : "Active")
                        .font(.system(size: 13, weight: .semibold))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(doctor.onLeave ? Color.orange : Color.green)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .padding(.top, 16)
                .padding(.bottom, 8)

                // Information Sections with adaptive layout
                LazyVGrid(columns: [GridItem(.adaptive(minimum: sizeClass == .regular ? 500 : 300))], spacing: 20) {
                    // Personal Information Section
                    InfoSectionCard(title: "Personal Information") {
                        InfoRow(icon: "person.fill", label: "Full Name", value: doctor.fullName)
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "calendar", label: "Date of Birth", value: formatDate(doctor.dateOfBirth))
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "person.2.fill", label: "Gender", value: "Other")
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "phone.fill", label: "Contact Number", value: doctor.contactNumber)
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "envelope.fill", label: "Email Address", value: doctor.emailAddress)
                    }

                    // Professional Information Section
                    InfoSectionCard(title: "Professional Information") {
                        InfoRow(icon: "creditcard.fill", label: "Medical License Number", value: doctor.licenseId)
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "cross.case.fill", label: "Specialization", value: doctor.specialization)
                        if doctor.yearOfExperience > 0 {
                            Divider().padding(.leading, 40)
                            InfoRow(icon: "clock.fill", label: "Years of Experience", value: "\(doctor.yearOfExperience) Years")
                        }
                    }

                    // Department Section
                    InfoSectionCard(title: "Department & Schedule") {
                        InfoRow(icon: "building.2.fill", label: "Department", value: doctor.department)
                    }
                }

                // Add reviews section at the bottom
                ReviewSection(reviews: reviews, doctor: doctor)

                // Bottom padding for scroll view
                Color.clear.frame(height: 20)
            }
            .padding(.horizontal)
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Doctor Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingDeleteConfirmation = true
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(
                title: Text("Delete Doctor"),
                message: Text("Are you sure you want to delete Dr. \(doctor.fullName)? This action cannot be undone."),
                primaryButton: .destructive(Text("Delete")) {
                    deleteDoctor()
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            // Load reviews when view appears
            loadReviews()
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }

    private func deleteDoctor() {
        Task {
            let deleted = await DataController.shared.deleteDoctor(doctor)
            if deleted {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }

    private func loadReviews() {
        // Temporary mock data for testing
        reviews = [
            Review(patientName: "Patient 1",
                  rating: 4,
                  comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
                  date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date()),
            Review(patientName: "Patient 1",
                  rating: 4,
                  comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
                  date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date()),
            Review(patientName: "Patient 1",
                  rating: 4,
                  comment: "Dashing through the snow. On a one horse open sleigh. Over the hills we go, laughing all the way.",
                  date: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date())
        ]
    }
}

struct InfoSectionCard<Content: View>: View {

    // MARK: Lifecycle

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    // MARK: Internal

    let title: String
    let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .padding(.leading, 8)

            VStack(spacing: 0) {
                content
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
    }
}

// Improved Info Row with proper SF Symbols
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .frame(width: 24)
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 5) {
                Text(label)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color(.systemGray))

                Text(value)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.primary)
            }

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct ReviewSection: View {
    let reviews: [Review]
    let doctor: Staff
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Reviews")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                NavigationLink(destination: DoctorReviewsView(doctor: doctor)) {
                    Text("See All")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            if reviews.isEmpty {
                Text("No reviews yet")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            } else {
                ForEach(reviews) { review in
                    NavigationLink(destination: DoctorReviewsView(doctor: doctor)) {
                        ReviewCard(review: review)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(.vertical)
    }
}

struct ReviewCard: View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Patient name and rating in one row
            HStack(alignment: .center) {
                Text(review.patientName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Text(String(format: "%.1f", review.rating))
                        .font(.system(size: 20, weight: .semibold))
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 16))
                }
            }
            
            // Date
            Text(review.date.formatted(date: .numeric, time: .omitted))
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.top, 2)
            
            // Review comment
            Text(review.comment)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.top, 8)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 255/255, green: 255/255, blue: 255/255))
        .cornerRadius(16)
        .padding(.horizontal, 4)
    }
}
