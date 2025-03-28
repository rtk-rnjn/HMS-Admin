import SwiftUI
import MapKit
import CoreLocation

struct HospitalOnboardingView: View {

    // MARK: Internal

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
                            if !hospitalNameError.isEmpty {
                                Text(hospitalNameError)
                                    .font(.caption2)
                                    .foregroundColor(.red)
                            }
                        }

                        .padding(.vertical, 4)

                        VStack(alignment: .leading, spacing: 2) {
                            TextField("Contact Number", text: $contactNumber)
                                .keyboardType(.phonePad)
                                .textContentType(.telephoneNumber)
                                .font(.body)
                            if !contactNumberError.isEmpty {
                                Text(contactNumberError)
                                    .font(.caption2)
                                    .foregroundColor(.red)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 4)

                        VStack(alignment: .leading, spacing: 4) {
                            if !hospitalAddress.isEmpty {
                                Text(hospitalAddress)
                                    .font(.body)
                                    .lineLimit(2)
                            } else {
                                Text("Hospital Address")
                                    .foregroundColor(.gray)
                            }

                            Button(action: {
                                showingMapPicker = true
                            }) {
                                HStack {
                                    Image(systemName: "map")
                                    Text("Select Location from Map")
                                        .font(.subheadline)
                                }
                                .foregroundColor(.blue)
                            }

                            if !hospitalAddressError.isEmpty {
                                Text(hospitalAddressError)
                                    .font(.caption2)
                                    .foregroundColor(.red)
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
                        if !licenseNumberError.isEmpty {
                            Text(licenseNumberError)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
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

                    if !departmentsError.isEmpty {
                        Text(departmentsError)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }

                // Submit Button Section
                Section {
                    Button(action: submitForm) {
                        Text("Complete Onboarding")
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
            .fullScreenCover(isPresented: $shouldNavigateToDashboard) {
                Color.clear
                    .ignoresSafeArea()
            }
            .onChange(of: shouldNavigateToDashboard) { newValue in
                if newValue {
                    // Get the window scene
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {

                        // Load the Initial storyboard
                        let storyboard = UIStoryboard(name: "Initial", bundle: nil)

                        // Create the tab bar controller from storyboard
                        if let tabBarController = storyboard.instantiateInitialViewController() {
                            // Set it as the root view controller
                            window.rootViewController = tabBarController
                            window.makeKeyAndVisible()
                        }
                    }
                }
            }
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

    // Location manager for getting user's current location
    @StateObject private var locationManager: LocationManager = .init()

    // Validation states
    @State private var hospitalNameError = ""
    @State private var contactNumberError = ""
    @State private var hospitalAddressError = ""
    @State private var licenseNumberError = ""
    @State private var departmentsError = ""

    private func submitForm() {
        // Reset errors
        hospitalNameError = ""
        contactNumberError = ""
        hospitalAddressError = ""
        licenseNumberError = ""
        departmentsError = ""

        var isValid = true

        // Validate Hospital Name
        if hospitalName.isEmpty {
            hospitalNameError = "Hospital name is required"
            isValid = false
        }

        // Validate Contact Number
        if contactNumber.isEmpty {
            contactNumberError = "Contact number is required"
            isValid = false
        } else if !isValidPhoneNumber(contactNumber) {
            contactNumberError = "Please enter a valid phone number"
            isValid = false
        }

        // Validate Hospital Address
        if hospitalAddress.isEmpty {
            hospitalAddressError = "Hospital address is required"
            isValid = false
        }

        // Validate License Number
        if licenseNumber.isEmpty {
            licenseNumberError = "License number is required"
            isValid = false
        }

        // Validate Departments
        if departments.isEmpty {
            departmentsError = "At least one department is required"
            isValid = false
        }

        if isValid {
            // Create hospital data
            let hospitalData = HospitalData(
                name: hospitalName,
                contactNumber: contactNumber,
                address: hospitalAddress,
                location: selectedLocation,
                licenseNumber: licenseNumber,
                licenseValidUntil: licenseValidUntil,
                departments: departments
            )

            // TODO: Submit the form data to your backend
            print("Form submitted successfully")

            // Navigate to dashboard
            shouldNavigateToDashboard = true
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

// Hospital Data Model
struct HospitalData {
    let name: String
    let contactNumber: String
    let address: String
    let location: CLLocationCoordinate2D?
    let licenseNumber: String
    let licenseValidUntil: Date
    let departments: [String]
}

#Preview {
    HospitalOnboardingView()
}
