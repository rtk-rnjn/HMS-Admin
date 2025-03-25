import SwiftUI
// No need for explicit import as all files in the same module can access each other

struct DoctorListView: View {
    @StateObject private var doctorStore = DoctorStore.shared
    @State private var searchText = ""
    @State private var showingAddDoctorView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background color that covers the entire screen
                Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                
                // Main content
                VStack(alignment: .leading, spacing: 0) {
                    // Custom title and add button
                    HStack {
                        Text("Doctors")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            showingAddDoctorView = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search doctors", text: $searchText)
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                    
                    // Doctors list
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredDoctors, id: \.id) { doctor in
                                DoctorCard(doctor: doctor).environmentObject(doctorStore)
                            }
                            
                            if filteredDoctors.isEmpty {
                                VStack(spacing: 12) {
                                    Image(systemName: "person.crop.circle.badge.questionmark")
                                        .font(.system(size: 50))
                                        .foregroundColor(.gray)
                                    
                                    Text(searchText.isEmpty ? "No doctors found" : "No matching doctors")
                                        .font(.headline)
                                        .foregroundColor(.gray)
                                    
                                    if !searchText.isEmpty {
                                        Button(action: {
                                            searchText = ""
                                        }) {
                                            Text("Clear Search")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.top, 50)
                            }
                            
                            // Add some bottom padding
                            Color.clear.frame(height: 20)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddDoctorView) {
                AddDoctorView().environmentObject(doctorStore)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var filteredDoctors: [Staff] {
        if searchText.isEmpty {
            return doctorStore.doctors
        } else {
            return doctorStore.doctors.filter {
                $0.fullName.lowercased().contains(searchText.lowercased()) ||
                $0.department.lowercased().contains(searchText.lowercased()) ||
                $0.specializations.joined(separator: ", ").lowercased().contains(searchText.lowercased())
            }
        }
    }
}

struct DoctorCard: View {
    let doctor: Staff
    @EnvironmentObject var doctorStore: DoctorStore
    
    var body: some View {
        NavigationLink(destination: DoctorProfileView(doctor: doctor).environmentObject(doctorStore)) {
            HStack(spacing: 12) {
                // Profile image
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(Color(.systemGray3))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                
                VStack(alignment: .leading, spacing: 4) {
                    // Name
                    Text(doctor.fullName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    // Department and specialization
                    Text(doctor.department)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                    
                    Text(doctor.specializations.joined(separator: ", "))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Status indicator - small dot instead of badge for cleaner list
                Circle()
                    .fill(doctor.onLeave ? Color.orange : Color.green)
                    .frame(width: 10, height: 10)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        }
    }
}

struct DoctorListView_Previews: PreviewProvider {
    static var previews: some View {
        DoctorListView()
    }
} 