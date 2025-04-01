import SwiftUI
import MapKit
import CoreLocation

struct HospitalOnboardingView: View {

    // MARK: Internal

    weak var delegate: HospitalDetailHostingController?

    var body: some View {
        NavigationView {
            Form {
                // Hospital Details Section
                Section {
                    Group {
                        VStack(alignment: .leading, spacing: 2) {
                            TextField("Hospital Name", text: $hospitalName)
                                .textContentType(.organizationName)
                                .font(.body)
                        }
                        .padding(.vertical, 4)

                        VStack(alignment: .leading, spacing: 2) {
                            TextField("Contact Number", text: $contactNumber)
                                .keyboardType(.phonePad)
                                .textContentType(.telephoneNumber)
                                .font(.body)
                        }
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 4)

                        VStack(alignment: .leading, spacing: 4) {
                            Button(action: {
                                showingMapPicker = true
                            }) {
                                VStack(alignment: .leading, spacing: 8) {
                                    if !hospitalAddress.isEmpty {
                                        HStack(alignment: .top, spacing: 8) {
                                            Image(systemName: "location.fill")
                                                .foregroundColor(.blue)
                                            
                                            Text(hospitalAddress)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                                .multilineTextAlignment(.leading)
                                        }
                                        
                                        // Show mini map preview if location is selected
                                        if let lat = selectedLocation?.latitude,
                                           let long = selectedLocation?.longitude {
                                            Map(coordinateRegion: .constant(MKCoordinateRegion(
                                                center: CLLocationCoordinate2D(latitude: lat, longitude: long),
                                                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                            )), interactionModes: [], annotationItems: [MapLocation(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))]) { location in
                                                MapMarker(coordinate: location.coordinate, tint: .blue)
                                            }
                                            .frame(height: 120)
                                            .cornerRadius(8)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                        }
                                    } else {
                                        HStack {
                                            Image(systemName: "map")
                                                .foregroundColor(.blue)
                                            Text("Select Hospital Location")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemBackground))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 4)
                    }
                }
                .listRowBackground(Color(.systemBackground))
                .listSectionSeparator(.hidden)

                // License Details Section
                Section(header: Text("License Details")) {
                    VStack(alignment: .leading, spacing: 4) {
                        TextField("License Number", text: $licenseNumber)
                    }

                    DatePicker("Valid Until",
                              selection: $licenseValidUntil,
                              in: Date()...,
                              displayedComponents: .date)
                        .datePickerStyle(.compact)
                }

                // Departments Section
                Section(header: Text("Departments")) {
                    ForEach(departments, id: \.self) { department in
                        HStack {
                            Text(department)
                            Spacer()
                            Button(action: {
                                departments.removeAll { $0 == department }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }

                    Button(action: {
                        showingAddDepartment = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Department")
                        }
                    }
                }

                // Submit Button Section
                Section {
                    Button(action: submitForm) {
                        Text("Register Hospital")
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Hospital Registration")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button("Back") {
                dismiss()
            })
            .alert("Validation Error", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .sheet(isPresented: $showingAddDepartment) {
                NavigationView {
                    Form {
                        Section {
                            TextField("Department Name", text: $newDepartment)
                                .autocapitalization(.words)
                        }
                    }
                    .navigationTitle("Add Department")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                newDepartment = ""
                                showingAddDepartment = false
                            }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                if !newDepartment.isEmpty {
                                    departments.append(newDepartment)
                                    newDepartment = ""
                                    showingAddDepartment = false
                                }
                            }
                            .disabled(newDepartment.isEmpty)
                        }
                    }
                }
                .presentationDetents([.height(200)])
            }
            .sheet(isPresented: $showingMapPicker) {
                NavigationView {
                    MapLocationPicker(selectedLocation: $selectedLocation,
                                    address: $hospitalAddress,
                                    isPresented: $showingMapPicker)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
        }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss
    @State private var shouldNavigateToDashboard = false
    @State private var hospitalName = ""
    @State private var contactNumber = ""
    @State private var hospitalAddress = ""
    @State private var licenseNumber = ""
    @State private var licenseValidUntil: Date = .init()
    @State private var departments: [String] = []
    @State private var showingAddDepartment = false
    @State private var newDepartment = ""
    @State private var showingMapPicker = false
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var showingAlert = false
    @State private var alertMessage = ""

    // Location manager for getting user's current location
    @StateObject private var locationManager: LocationManager = .init()

    private func submitForm() {
        // Validate Hospital Name
        if hospitalName.isEmpty {
            alertMessage = "Hospital name is required"
            showingAlert = true
            return
        }

        // Validate Contact Number
        if contactNumber.isEmpty {
            alertMessage = "Contact number is required"
            showingAlert = true
            return
        } else if !isValidPhoneNumber(contactNumber) {
            alertMessage = "Please enter a valid phone number"
            showingAlert = true
            return
        }

        // Validate Hospital Address
        if hospitalAddress.isEmpty {
            alertMessage = "Hospital address is required"
            showingAlert = true
            return
        }

        // Validate License Number
        if licenseNumber.isEmpty {
            alertMessage = "License number is required"
            showingAlert = true
            return
        }

        // Validate Departments
        if departments.isEmpty {
            alertMessage = "At least one department is required"
            showingAlert = true
            return
        }

        guard let admin = DataController.shared.admin else { fatalError() }
        let hospital = Hospital(name: hospitalName, 
                             address: hospitalAddress, 
                             contact: contactNumber, 
                             departments: departments, 
                             latitude: selectedLocation?.latitude, 
                             longitude: selectedLocation?.longitude, 
                             adminId: admin.id, 
                             hospitalLicenceNumber: licenseNumber)

        Task {
            let created = await DataController.shared.createHospital(hospital)
            if created {
                DispatchQueue.main.async {
                    // Show success view
                    let successView = HospitalOnboardingSuccessView(hospital: hospital, delegate: delegate)
                    let hostingController = UIHostingController(rootView: successView)
                    hostingController.modalPresentationStyle = .fullScreen
                    hostingController.modalTransitionStyle = .crossDissolve
                    hostingController.isModalInPresentation = true // Prevents dismissal by swipe
                    
                    // Ensure we're presenting from the top-most view controller
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let topController = windowScene.windows.first?.rootViewController?.topMostViewController {
                        topController.present(hostingController, animated: true)
                    } else {
                        delegate?.present(hostingController, animated: true)
                    }
                }
            }
        }
    }

    private func isValidPhoneNumber(_ number: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: number)
    }
}

// Location Manager to handle location permissions and updates
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    // MARK: Lifecycle

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: Internal

    @Published var location: CLLocation?

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    // MARK: Private

    private let locationManager: CLLocationManager = .init()

}

// Map Location Picker View
struct MapLocationPicker: View {

    // MARK: Internal

    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var address: String
    @Binding var isPresented: Bool

    var body: some View {
        ZStack(alignment: .top) {
            // Map View
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: selectedMapItem.map { [$0] } ?? []) { item in
                MapAnnotation(coordinate: item.placemark.coordinate) {
                    VStack(spacing: 0) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)

                        Image(systemName: "arrowtriangle.down.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                            .offset(x: 0, y: -5)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onTapGesture { _ in
                let coordinate = region.center
                reverseGeocode(coordinate)
            }

            // Search UI
            VStack(spacing: 0) {
                // Search Bar
                VStack(spacing: 0) {
                    SearchBar(text: $searchText, onSearchButtonClicked: performSearch)
                        .padding()
                        .background(Color(.systemBackground))

                    // Search Results
                    if showingSearchResults && !searchResults.isEmpty {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                ForEach(searchResults) { item in
                                    Button(action: { selectLocation(item) }) {
                                        SearchResultRow(mapItem: item)
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    if item.id != searchResults.last?.id {
                                        Divider()
                                            .padding(.leading)
                                    }
                                }
                            }
                            .background(Color(.systemBackground))
                        }
                        .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                    }
                }
                .shadow(radius: 2)

                if isLoadingAddress {
                    ProgressView("Getting address...")
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding()
                }

                if let selectedItem = selectedMapItem {
                    // Selected Location Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text(selectedItem.name ?? "Selected Location")
                            .font(.headline)

                        Text(selectedItem.placemark.formattedAddress)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        HStack {
                            Spacer()

                            Button(action: {
                                address = selectedItem.placemark.formattedAddress
                                selectedLocation = selectedItem.placemark.coordinate
                                isPresented = false
                            }) {
                                Text("Confirm Location")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(height: 44)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }

                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding()
                }

                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Select Location")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    isPresented = false
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    locationManager.requestLocation()
                    if let location = locationManager.location {
                        region.center = location.coordinate
                        region.span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        reverseGeocode(location.coordinate)
                    }
                }) {
                    Image(systemName: "location.fill")
                }
            }
        }
        .onChange(of: searchText) { _ in
            if !searchText.isEmpty {
                performSearch()
                showingSearchResults = true
            } else {
                searchResults = []
                showingSearchResults = false
            }
        }
    }

    // MARK: Private

    @StateObject private var locationManager: LocationManager = .init()
    @State private var region: MKCoordinateRegion = .init(
        center: CLLocationCoordinate2D(latitude: 37.3361, longitude: -122.0380),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var selectedMapItem: MKMapItem?
    @State private var showingSearchResults = false
    @State private var isLoadingAddress = false

    private func reverseGeocode(_ coordinate: CLLocationCoordinate2D) {
        isLoadingAddress = true
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            isLoadingAddress = false

            if let error {
                print("Reverse geocoding error: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                let mkPlacemark = MKPlacemark(placemark: placemark)
                let mapItem = MKMapItem(placemark: mkPlacemark)
                selectLocation(mapItem)
            }
        }
    }

    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region

        MKLocalSearch(request: request).start { response, error in
            guard let response else {
                print("Search error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            searchResults = response.mapItems
        }
    }

    private func selectLocation(_ item: MKMapItem) {
        selectedMapItem = item
        showingSearchResults = false
        searchText = item.name ?? ""

        withAnimation {
            region.center = item.placemark.coordinate
            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        }
    }
}

// Search Result Row View
struct SearchResultRow: View {
    let mapItem: MKMapItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundColor(.red)

            VStack(alignment: .leading, spacing: 4) {
                Text(mapItem.name ?? "")
                    .font(.body)
                    .foregroundColor(.primary)

                Text(mapItem.placemark.formattedAddress)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }

            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
    }
}

// Search Bar View
struct SearchBar: View {
    @Binding var text: String

    var onSearchButtonClicked: () -> Void

    var body: some View {
        HStack {
            TextField("Search for location", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    onSearchButtonClicked()
                }

            Button(action: onSearchButtonClicked) {
                Image(systemName: "magnifyingglass")
            }
        }
    }
}

// Extension to format address from placemark
extension MKPlacemark {
    var formattedAddress: String {
        let components = [
            thoroughfare,
            subThoroughfare,
            locality,
            administrativeArea,
            postalCode,
            country
        ].compactMap { $0 }

        return components.joined(separator: ", ")
    }
}

extension MKMapItem: Identifiable {
    public var id: String {
        return "\(placemark.coordinate.latitude),\(placemark.coordinate.longitude)"
    }
}

// MARK: - Haptic Feedback Manager
final class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func playSelection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

// MARK: - Success View Components
struct HospitalOnboardingSuccessView: View {
    let hospital: Hospital
    @Environment(\.dismiss) private var dismiss
    weak var delegate: HospitalDetailHostingController?
    @State private var showCheckmark = false
    @State private var showTitle = false
    @State private var showCard = false
    @State private var showMap = false
    @State private var showButtons = false
    
    var body: some View {
        VStack(spacing: 24) {
            SuccessHeader(showCheckmark: showCheckmark, showTitle: showTitle)
            
            HospitalInfoCard(hospital: hospital)
                .opacity(showCard ? 1 : 0)
                .offset(y: showCard ? 0 : 20)
            
            LocationMapView(
                latitude: hospital.latitude,
                longitude: hospital.longitude,
                address: hospital.address,
                isVisible: showMap
            )
            .opacity(showMap ? 1 : 0)
            .offset(y: showMap ? 0 : 20)
            
            Spacer()
            
            ActionButtons(delegate: delegate, dismiss: dismiss)
                .opacity(showButtons ? 1 : 0)
                .offset(y: showButtons ? 0 : 20)
        }
        .padding(.vertical, 32)
        .onAppear {
            animateEntrance()
        }
    }
    
    private func animateEntrance() {
        // Initial success haptic
        HapticManager.shared.playSuccess()
        
        // Staggered animations with haptic feedback
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            showCheckmark = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showTitle = true
            }
            HapticManager.shared.playSelection()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showCard = true
            }
            HapticManager.shared.playSelection()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showMap = true
            }
            HapticManager.shared.playSelection()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showButtons = true
            }
            HapticManager.shared.playSelection()
        }
    }
}

// MARK: - Success Header
private struct SuccessHeader: View {
    let showCheckmark: Bool
    let showTitle: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Circle()
                .fill(Color.green)
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "checkmark")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(showCheckmark ? 1 : 0.5)
                        .opacity(showCheckmark ? 1 : 0)
                )
                .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 4)
                .scaleEffect(showCheckmark ? 1 : 0.5)
            
            Text("Hospital Added Successfully!")
                .font(.title2)
                .fontWeight(.bold)
                .opacity(showTitle ? 1 : 0)
                .offset(y: showTitle ? 0 : 10)
        }
    }
}

// MARK: - Hospital Info Card
private struct HospitalInfoCard: View {
    let hospital: Hospital
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HospitalHeader(hospital: hospital)
            Divider()
            HospitalDetails(hospital: hospital)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
        .transition(.scale.combined(with: .opacity))
    }
}

private struct HospitalHeader: View {
    let hospital: Hospital
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: "building.2")
                        .font(.title2)
                        .foregroundColor(.gray)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(hospital.name)
                    .font(.headline)
                Text("License: \(hospital.hospitalLicenceNumber)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

private struct HospitalDetails: View {
    let hospital: Hospital
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            InfoRow(icon: "phone.fill", label: "Contact", value: hospital.contact ?? "Not provided")
            InfoRow(icon: "building.2.fill", label: "Departments", value: "\(hospital.departments.count) Departments")
        }
    }
}

// MARK: - Location Map View
private struct LocationMapView: View {
    let latitude: Double?
    let longitude: Double?
    let address: String?
    let isVisible: Bool
    @State private var showOverlay = false
    
    var body: some View {
        Group {
            if let latitude = latitude, let longitude = longitude {
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                ZStack(alignment: .top) {
                    Map(coordinateRegion: .constant(MKCoordinateRegion(
                        center: coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )), interactionModes: [], annotationItems: [MapLocation(coordinate: coordinate)]) { location in
                        MapMarker(coordinate: location.coordinate, tint: .blue)
                    }
                    
                    // Address Overlay
                    if let address = address {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack(spacing: 8) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.gray)
                                Text(address)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                            }
                        }
                        .padding(12)
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        .padding(.top, 12)
                        .opacity(showOverlay ? 1 : 0)
                        .offset(y: showOverlay ? 0 : -10)
                    }
                }
                .frame(height: 200)
                .cornerRadius(12)
                .padding(.horizontal)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                .onChange(of: isVisible) { newValue in
                    if newValue {
                        withAnimation(.easeOut.delay(0.3)) {
                            showOverlay = true
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Action Buttons
private struct ActionButtons: View {
    weak var delegate: HospitalDetailHostingController?
    let dismiss: DismissAction
    @State private var viewProfileScale: CGFloat = 1
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                viewProfileScale = 0.95
            }
            HapticManager.shared.playSuccess()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    viewProfileScale = 1
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                // Set user state
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                UserDefaults.standard.set(true, forKey: "isHospitalOnboarded")
                
                // Navigate to dashboard
                delegate?.navigateToDashboard()
            }
        }) {
            ButtonLabel(title: "Go to Home", style: .primary)
                .scaleEffect(viewProfileScale)
        }
        .padding(.horizontal)
    }
}

// MARK: - Button Label
private struct ButtonLabel: View {
    let title: String
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary
        case secondary
        
        var backgroundColor: Color {
            switch self {
            case .primary: return .blue
            case .secondary: return .blue.opacity(0.1)
            }
        }
        
        var foregroundColor: Color {
            switch self {
            case .primary: return .white
            case .secondary: return .blue
            }
        }
    }
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(style.foregroundColor)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(style.backgroundColor)
            .cornerRadius(12)
    }
}

// MARK: - Supporting Types
private struct MapLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

// MARK: - Preview
#Preview {
    HospitalOnboardingView()
}

#Preview {
    NavigationView {
        let mockHospital = Hospital(
            name: "City General Hospital",
            address: "123 Medical Center Blvd",
            contact: "+1 (555) 123-4567",
            departments: ["Cardiology", "Neurology", "Pediatrics"],
            latitude: 37.7749,
            longitude: -122.4194,
            adminId: "admin123",
            hospitalLicenceNumber: "LIC-2024-001"
        )
        
        HospitalOnboardingSuccessView(hospital: mockHospital, delegate: nil)
            .preferredColorScheme(.light)
    }
}

extension UIViewController {
    var topMostViewController: UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? self
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? self
        }
        return self
    }
}


