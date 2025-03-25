import SwiftUI
// No need for explicit import as all files in the same module can access each other

struct DoctorProfileView: View {
    let doctor: Staff
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var sizeClass
    @EnvironmentObject var doctorStore: DoctorStore
    @State private var showingDeleteConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Image and Name Section with adaptive sizing
                VStack(spacing: 16) {
                    // Circular profile picture with shadow
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: sizeClass == .regular ? 140 : 120, height: sizeClass == .regular ? 140 : 120)
                        .foregroundColor(Color(.systemGray4))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    
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
                        InfoRow(icon: "cross.case.fill", label: "Specialization", value: doctor.specializations.joined(separator: ", "))
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
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func deleteDoctor() {
        doctorStore.deleteDoctor(id: doctor.id)
        presentationMode.wrappedValue.dismiss()
    }
}

// Redesigned Section Card with improved styling
struct InfoSectionCard<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
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
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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

struct DoctorProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DoctorProfileView(doctor: Staff.preview)
                .previewDisplayName("iPhone")
            
            DoctorProfileView(doctor: Staff.preview)
                .previewDevice("iPad Pro (11-inch)")
                .previewDisplayName("iPad")
        }
    }
} 