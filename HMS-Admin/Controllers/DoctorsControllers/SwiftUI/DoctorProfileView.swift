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
    
    // Initialize haptic feedback generators
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sizeClass == .regular ? 140 : 120, height: sizeClass == .regular ? 140 : 120)
                        .foregroundColor(Color("iconBlue"))
                        .clipShape(Circle())
                        .onTapGesture {
                            impactFeedback.impactOccurred(intensity: 0.5)
                        }

                    // Name with "Dr." prefix
                    Text("Dr. \(doctor.fullName)")
                        .font(.system(size: 22, weight: .bold))

                    // Redesigned smaller status badge
                    Button(action: {
                        impactFeedback.impactOccurred(intensity: 0.7)
                    }) {
                        Text(doctor.onLeave ? "Inactive" : "Active")
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(doctor.onLeave ? Color("uselectedBlue") : Color("successBlue"))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 8)

                // Information Sections with adaptive layout
                LazyVGrid(columns: [GridItem(.adaptive(minimum: sizeClass == .regular ? 500 : 300))], spacing: 20) {
                    // Personal Information Section
                    InfoSectionCard(title: "Personal Information") {
                        InfoRow(icon: "person.fill", label: "Full Name", value: doctor.fullName)
                            .onTapGesture { impactFeedback.impactOccurred(intensity: 0.5) }
                        Divider().padding(.leading, 40)

                        InfoRow(icon: "calendar", label: "Date of Birth", value: formatDate(doctor.dateOfBirth))
                            .onTapGesture { impactFeedback.impactOccurred(intensity: 0.5) }
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "person.2.fill", label: "Gender", value: "Other")
                            .onTapGesture { impactFeedback.impactOccurred(intensity: 0.5) }
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "phone.fill", label: "Contact Number", value: doctor.contactNumber)
                            .onTapGesture { impactFeedback.impactOccurred(intensity: 0.5) }
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "envelope.fill", label: "Email Address", value: doctor.emailAddress)
                            .onTapGesture { impactFeedback.impactOccurred(intensity: 0.5) }
                    }

                    // Professional Information Section
                    InfoSectionCard(title: "Professional Information") {
                        InfoRow(icon: "creditcard.fill", label: "Medical License Number", value: doctor.licenseId)
                            .onTapGesture { impactFeedback.impactOccurred(intensity: 0.5) }
                        Divider().padding(.leading, 40)
                        InfoRow(icon: "cross.case.fill", label: "Specialization", value: doctor.specialization)
                            .onTapGesture { impactFeedback.impactOccurred(intensity: 0.5) }
                        if doctor.yearOfExperience > 0 {
                            Divider().padding(.leading, 40)
                            InfoRow(icon: "clock.fill", label: "Years of Experience", value: "\(doctor.yearOfExperience) Years")
                                .onTapGesture { impactFeedback.impactOccurred(intensity: 0.5) }
                        }
                    }

                    // Department Section
                    InfoSectionCard(title: "Department & Schedule") {
                        InfoRow(icon: "building.2.fill", label: "Department", value: doctor.department)
                            .onTapGesture { impactFeedback.impactOccurred(intensity: 0.5) }
                    }
                }

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
                    // Prepare and trigger haptics for delete confirmation
                    impactFeedback.prepare()
                    notificationFeedback.prepare()
                    impactFeedback.impactOccurred(intensity: 1.0)
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
                    notificationFeedback.prepare()
                    notificationFeedback.notificationOccurred(.error)
                    Task {
                        if await DataController.shared.deleteDoctor(doctor) {
                            notificationFeedback.prepare()
                            notificationFeedback.notificationOccurred(.success)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            notificationFeedback.prepare()
                            notificationFeedback.notificationOccurred(.error)
                        }
                    }
                },
                secondaryButton: .cancel {
                    impactFeedback.prepare()
                    impactFeedback.impactOccurred(intensity: 0.5)
                }
            )
        }
        .onAppear {
            // Prepare haptic generators when view appears
            impactFeedback.prepare()
            notificationFeedback.prepare()
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
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
                .foregroundColor(Color("iconBlue"))

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
