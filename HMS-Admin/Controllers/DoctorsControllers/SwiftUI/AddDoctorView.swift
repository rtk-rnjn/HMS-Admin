//
//  AddDoctorView.swift
//  HMS-Admin
//

//

import SwiftUI
import MapKit
import CoreLocation

// Import DoctorSuccessView
@_spi(HMS) import HMS_Admin

struct AddDoctorView: View {

    // MARK: Lifecycle

    init(doctor: Staff? = nil) {
        self.doctor = doctor

        if let doctor {
            _firstName = State(initialValue: doctor.firstName)
            _lastName = State(initialValue: doctor.lastName ?? "")
            _contactNumber = State(initialValue: doctor.contactNumber)
            _email = State(initialValue: doctor.emailAddress)
            _dateOfBirth = State(initialValue: doctor.dateOfBirth)
            _selectedGender = State(initialValue: doctor.gender)
            _medicalLicenseNumber = State(initialValue: doctor.licenseId)
            _yearsOfExperience = State(initialValue: doctor.yearOfExperience)
            _consultationFee = State(initialValue: String(doctor.consultationFee))
            _department = State(initialValue: doctor.department)
            _specialization = State(initialValue: doctor.specialization)
        } else {
            // Set default gender to male for new doctors
            _selectedGender = State(initialValue: .male)
        }
    }

    // MARK: Internal

    var delegate: AddDoctorHostingController?

    let doctor: Staff?
    let departments = [
        "Cardiology",
        "Neurology",
        "Orthopedics",
        "Pediatrics",
        "Gynecology & Obstetrics",
        "Oncology",
        "Radiology",
        "Emergency & Trauma",
        "Dermatology",
        "Psychiatry",
        "Gastroenterology",
        "Nephrology",
        "Endocrinology",
        "Pulmonology",
        "Ophthalmology",
        "ENT (Ear, Nose, Throat)",
        "Urology",
        "Anesthesiology",
        "Pathology & Lab Medicine"
    ]

    let specializations = [
        "Cardiologist",
        "Neurologist",
        "Orthopedic Surgeon",
        "Pediatrician",
        "Gynecologist/Obstetrician",
        "Oncologist",
        "Radiologist",
        "Emergency Medicine Specialist",
        "Dermatologist",
        "Psychiatrist",
        "Gastroenterologist",
        "Nephrologist",
        "Endocrinologist",
        "Pulmonologist",
        "Ophthalmologist",
        "ENT Specialist",
        "Urologist",
        "Anesthesiologist",
        "Hematologist",
        "Rheumatologist"
    ]

    let genderOptions = ["Male", "Female", "Other"]

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 24) {
                        // Header Image
                        VStack(spacing: 16) {
                            Image(systemName: "person.fill.badge.plus")
                                .font(.largeTitle)
                                .foregroundColor(Color("iconBlue"))

                                .padding(.top, 20)

                            Text(doctor == nil ? "Add New Doctor" : "Edit Doctor")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)

                            Text("Fill in the doctor's information below")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)

                        // Personal Information Section
                        GroupBox {
                            VStack(alignment: .leading, spacing: 20) {
                                SectionHeader(title: "Personal Information", icon: "person.fill")

                                // First Name
                                ValidatedTextField(
                                    title: "First Name",
                                    text: $firstName,
                                    error: firstNameError,
                                    onChange: { _ in
                                        if !firstName.isEmpty {
                                            firstNameError = ""
                                        }
                                    }
                                )

                                // Last Name
                                ValidatedTextField(
                                    title: "Last Name",
                                    text: $lastName,
                                    error: lastNameError,
                                    onChange: { _ in
                                        if !lastName.isEmpty {
                                            lastNameError = ""
                                        }
                                    }
                                )

                                // Contact Number
                                ValidatedTextField(
                                    title: "Contact Number",
                                    text: $contactNumber,
                                    error: contactNumberError,
                                    keyboardType: .numberPad,
                                    onChange: { newValue in
                                        let filtered = newValue.filter { $0.isNumber }
                                        if filtered != newValue {
                                            contactNumber = filtered
                                        }
                                        if filtered.count > 10 {
                                            contactNumber = String(filtered.prefix(10))
                                        }
                                        if !contactNumber.isEmpty {
                                            contactNumberError = ""
                                        }
                                    }
                                )

                                // Email
                                ValidatedTextField(
                                    title: "Email",
                                    text: $email,
                                    error: emailError,
                                    keyboardType: .emailAddress,
                                    autocapitalization: .none,
                                    onChange: { _ in
                                        if !email.isEmpty && isValidEmail(email) {
                                            emailError = ""
                                        }
                                    }
                                )

                                // Date of Birth
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(Color("iconBlue"))
                                    Text("Date of Birth")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    }

                                    Button(action: {
                                        withAnimation {
                                            dateOfBirthHasInteracted = true
                                            showingDatePicker = true
                                        }
                                    }) {
                                        HStack {
                                            Text(dateOfBirth?.formatted(date: .long, time: .omitted) ?? "Select Date of Birth")
                                                .foregroundColor(dateOfBirth == nil ? .gray : .black)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(dateOfBirthHasInteracted && !dateOfBirthError.isEmpty ? Color.red : Color.gray.opacity(0.2), lineWidth: 1)
                                        )

                                    }

                                        .onChange(of: dateOfBirth) { _, _ in
                                            dateOfBirthError = ""
                                        }

                                    if dateOfBirthHasInteracted && !dateOfBirthError.isEmpty {
                                        Text(dateOfBirthError)
                                            .font(.footnote)
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 4)
                                    }
                                }

                                // Gender Selection
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "person.2.fill")
                                            .foregroundColor(Color("iconBlue"))
                                    Text("Gender")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    }

                                    Menu {
                                        Picker("Gender", selection: $selectedGender) {
                                            Text("Male").tag(Gender.male)
                                            Text("Female").tag(Gender.female)
                                            Text("Other").tag(Gender.other)
                                        }
                                    } label: {
                                        HStack {
                                            Text(selectedGender.rawValue)
                                                .foregroundColor(.black)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                    }
                                }
                            }
                        }
                        .groupBoxStyle(CustomGroupBoxStyle())

                        // Professional Information Section
                        GroupBox {
                            VStack(alignment: .leading, spacing: 20) {
                                SectionHeader(title: "Professional Information", icon: "stethoscope")

                                // Medical License Number
                                ValidatedTextField(
                                    title: "Medical License Number",
                                    text: $medicalLicenseNumber,
                                    error: medicalLicenseError,
                                    onChange: { _ in
                                        if !medicalLicenseNumber.isEmpty {
                                            medicalLicenseError = ""
                                        }
                                    }
                                )

                                // Years of Experience
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "clock.fill")
                                            .foregroundColor(Color("iconBlue"))
                                    Text("Years of Experience")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    }

                                    Menu {
                                        Picker("Years of Experience", selection: $yearsOfExperience) {
                                            ForEach(availableYearsOfExperience, id: \.self) { year in
                                                Text("\(year) years").tag(year)
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(dateOfBirth == nil ? "Select Date of Birth First" : "\(yearsOfExperience) years")
                                                .foregroundColor(dateOfBirth == nil ? .gray : .black)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(yearsOfExperienceError.isEmpty ? Color.gray.opacity(0.2) : Color.red, lineWidth: 1)
                                        )
                                    }
                                    .disabled(dateOfBirth == nil)
                                    .opacity(dateOfBirth == nil ? 0.6 : 1)

                                    if !yearsOfExperienceError.isEmpty {
                                        Text(yearsOfExperienceError)
                                            .font(.footnote)
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 4)
                                    }
                                }

                                // Consultation Fee
                                ValidatedTextField(
                                    title: "Consultation Fee",
                                    text: $consultationFee,
                                    error: consultationFeeError,
                                    keyboardType: .decimalPad,
                                    onChange: { _ in
                                        if !consultationFee.isEmpty {
                                            consultationFeeError = ""
                                        }
                                    }
                                )
                            }
                        }
                        .groupBoxStyle(CustomGroupBoxStyle())

                        // Department & Specializations Section
                        GroupBox {
                            VStack(alignment: .leading, spacing: 20) {
                                SectionHeader(title: "Department & Specializations", icon: "building.2")

                                // Department
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "building.2.fill")
                                            .foregroundColor(Color("iconBlue"))
                                    Text("Department")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    }

                                    Menu {
                                        ForEach(departments, id: \.self) { dept in
                                            Button(action: {
                                                departmentHasInteracted = true
                                                department = dept
                                                departmentError = ""
                                                // Clear specializations when department changes
                                                selectedSpecializations.removeAll()
                                                specialization = ""
                                                checkFormValidity()
                                            }) {
                                                HStack {
                                                    Text(dept)
                                                    if department == dept {
                                                        Image(systemName: "checkmark")
                                                            .foregroundColor(Color("iconBlue"))
                                                    }
                                                }
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text(department.isEmpty ? "Select Department" : department)
                                                .foregroundColor(department.isEmpty ? .gray : .black)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(departmentHasInteracted && !departmentError.isEmpty ? Color.red : Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                    }

                                    if departmentHasInteracted && !departmentError.isEmpty {
                                        Text(departmentError)
                                            .font(.footnote)
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 4)
                                    }
                                }

                                // Specializations
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "cross.case.fill")
                                            .foregroundColor(Color("iconBlue"))
                                    Text("Specializations")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    }

                                    Button(action: {
                                        if !department.isEmpty {
                                            specializationHasInteracted = true
                                        showingSpecializationDropdown = true
                                        }
                                    }) {
                                        HStack {
                                            if specialization.isEmpty {
                                                Text(department.isEmpty ? "Select Department First" : "Select Specializations")
                                                    .foregroundColor(.gray)
                                            } else {
                                                Text(specialization)
                                                    .foregroundColor(.black)
                                                    .lineLimit(2)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(specializationHasInteracted && !specializationError.isEmpty ? Color.red : Color.gray.opacity(0.2), lineWidth: 1)
                                        )
                                    }
                                    .disabled(department.isEmpty)
                                    .opacity(department.isEmpty ? 0.6 : 1)

                                    if specializationHasInteracted && !specializationError.isEmpty {
                                        Text(specializationError)
                                            .font(.footnote)
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 4)
                                    }
                                }
                            }
                        }
                        .groupBoxStyle(CustomGroupBoxStyle())

                        // Availability Section
                        GroupBox {
                            VStack(alignment: .leading, spacing: 20) {
                                SectionHeader(title: "Availability", icon: "clock.fill")

                                // Working Days
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "calendar.badge.clock")
                                            .foregroundColor(Color("iconBlue"))
                                        Text("Working Days")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 8) {
                                            ForEach(weekDays, id: \.self) { day in
                                                Button(action: {
                                                    if selectedDays.contains(day) {
                                                        selectedDays.remove(day)
                                                    } else {
                                                        selectedDays.insert(day)
                                                    }
                                                }) {
                                                    Text(day.prefix(3))
                                                        .font(.subheadline)
                                                        .fontWeight(selectedDays.contains(day) ? .semibold : .regular)
                                                        .padding(.horizontal, 12)
                                                        .padding(.vertical, 8)
                                                        .background(selectedDays.contains(day) ? Color.blue : Color.clear)
                                                        .foregroundColor(selectedDays.contains(day) ? .white : .gray)
                                                        .cornerRadius(8)
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 8)
                                                                .stroke(selectedDays.contains(day) ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                                                        )
                                                }
                                            }
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }

                                // Working Hours
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "clock.badge.checkmark")
                                            .foregroundColor(Color("iconBlue"))
                                    Text("Working Hours")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    }

                                    HStack(spacing: 16) {
                                        // Start Time Button
                                        Button(action: {
                                            isEditingStartTime = true
                                            showingTimePickerSheet = true
                                        }) {
                                            VStack(alignment: .leading, spacing: 4) {
                                            Text("Start Time")
                                                    .font(.caption)
                                                .foregroundColor(.gray)
                                                HStack {
                                                    Text(startTime.formatted(date: .omitted, time: .shortened))
                                                        .font(.title3)
                                                        .foregroundColor(.primary)
                                                    Image(systemName: "chevron.down")
                                                        .foregroundColor(.gray)
                                                        .font(.caption)
                                                }
                                            }
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                        }

                                        // End Time Button
                                        Button(action: {
                                            isEditingStartTime = false
                                            showingTimePickerSheet = true
                                        }) {
                                            VStack(alignment: .leading, spacing: 4) {
                                            Text("End Time")
                                                    .font(.caption)
                                                .foregroundColor(.gray)
                                                HStack {
                                                    Text(endTime.formatted(date: .omitted, time: .shortened))
                                                        .font(.title3)
                                                        .foregroundColor(.primary)
                                                    Image(systemName: "chevron.down")
                                                        .foregroundColor(.gray)
                                                        .font(.caption)
                                        }
                                    }
                                    .padding()
                                            .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .groupBoxStyle(CustomGroupBoxStyle())
                    }
                    .padding()
                }
                .disabled(isLoading)
                .opacity(isLoading ? 0.6 : 1)

                if isLoading {
                    ZStack {
                        Color(.systemBackground)
                            .opacity(0.8)
                            .edgesIgnoringSafeArea(.all)

                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.5)
                            Text("Saving doctor information...")
                                .font(.headline)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingSpecializationDropdown) {
                NavigationView {
                    List(selection: $selectedSpecializations) {
                        ForEach(availableSpecializations, id: \.self) { spec in
                            HStack {
                                Text(spec)
                                Spacer()
                                if selectedSpecializations.contains(spec) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedSpecializations.contains(spec) {
                                    selectedSpecializations.remove(spec)
                                } else {
                                    selectedSpecializations.insert(spec)
                                }
                                specialization = Array(selectedSpecializations).sorted().joined(separator: ", ")
                                specializationError = ""
                                checkFormValidity()
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .navigationTitle("Select Specializations")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingSpecializationDropdown = false
                            }
                        }
                    }
                }
                .presentationDetents([.medium])
                .onAppear {
                    // Clear selected specializations if department changed
                    if !department.isEmpty {
                        let availableSpecs = Set(availableSpecializations)
                        selectedSpecializations = selectedSpecializations.intersection(availableSpecs)
                        specialization = Array(selectedSpecializations).sorted().joined(separator: ", ")
                    }
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                NavigationView {
                    DatePicker(
                        "Select Date of Birth",
                        selection: Binding(
                            get: { dateOfBirth ?? Date() },
                            set: { dateOfBirth = $0 }
                        ),
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .navigationTitle("Date of Birth")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                showingDatePicker = false
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingDatePicker = false
                                dateOfBirthError = ""
                                checkFormValidity()
                            }
                        }
                    }
                    .padding()
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingTimePickerSheet) {
                NavigationView {
                    VStack {
                        DatePicker(
                            isEditingStartTime ? "Select Start Time" : "Select End Time",
                            selection: isEditingStartTime ? $startTime : $endTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                        .padding()
                    }
                    .navigationTitle(isEditingStartTime ? "Start Time" : "End Time")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingTimePickerSheet = false
                            }
                        }
                    }
                }
                .presentationDetents([.height(300)])
            }
            .fullScreenCover(isPresented: $showingSuccessView) {
                if let doctor = savedDoctor {
                    DoctorSuccessView(
                        doctor: doctor,
                        onGoToHome: {
                            dismiss()
                        },
                        onAddAnotherDoctor: {
                            showingSuccessView = false
                            resetForm()
                        }
                    )
                }
            }
            .navigationTitle(doctor == nil ? "Add Doctor" : "Edit Doctor")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                }
                .disabled(isLoading),
                trailing: Button("Save") {
                    saveDoctor()
                }
                .disabled(isLoading || !isFormValid)
            )
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
        .onAppear {
            checkFormValidity()
        }

        .onChange(of: firstName) { _, _ in checkFormValidity() }
        .onChange(of: lastName) { _, _ in checkFormValidity() }
        .onChange(of: contactNumber) { _, _ in checkFormValidity() }
        .onChange(of: email) { _, _ in checkFormValidity() }
        .onChange(of: medicalLicenseNumber) { _, _ in checkFormValidity() }
        .onChange(of: consultationFee) { _, _ in checkFormValidity() }
        .onChange(of: department) { _, _ in checkFormValidity() }
        .onChange(of: specialization) { _, _ in checkFormValidity() }
        .onChange(of: yearsOfExperience) { _, _ in checkFormValidity() }
    }

    // MARK: Private

    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isFormValid = false

    @Environment(\.dismiss) private var dismiss

    // Personal Information
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var contactNumber = ""
    @State private var email = ""
    @State private var dateOfBirth: Date?
    @State private var selectedGender: Gender = .male

    // Professional Information
    @State private var medicalLicenseNumber = ""
    @State private var yearsOfExperience = 0
    @State private var showingYearsOfExperiencePicker = false
    @State private var consultationFee = ""

    // Department & Schedule
    @State private var department = ""
    @State private var specialization = ""

    // Validation errors
    @State private var firstNameError = ""
    @State private var lastNameError = ""
    @State private var contactNumberError = ""
    @State private var emailError = ""
    @State private var dateOfBirthError = ""
    @State private var medicalLicenseError = ""
    @State private var yearsOfExperienceError = ""
    @State private var consultationFeeError = ""
    @State private var departmentError = ""
    @State private var specializationError = ""

    // Dropdown state
    @State private var showingSpecializationDropdown = false
    @State private var selectedSpecializations: Set<String> = []

    // Availability states
    @State private var startTime = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
    @State private var endTime = Calendar.current.date(from: DateComponents(hour: 17, minute: 0)) ?? Date()

    // Add to the properties section
    @State private var showingDatePicker = false
    @State private var dateOfBirthHasInteracted = false
    @State private var departmentHasInteracted = false
    @State private var specializationHasInteracted = false

    // Add to properties section
    @State private var selectedDays: Set<String> = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    @State private var showingTimePickerSheet = false
    @State private var isEditingStartTime = true

    // Add department to specializations mapping
    private let departmentSpecializations: [String: [String]] = [
        "Cardiology": [
            "General Cardiologist",
            "Interventional Cardiologist",
            "Pediatric Cardiologist",
            "Electrophysiologist",
            "Heart Failure Specialist",
            "Cardiac Surgeon"
        ],
        "Neurology": [
            "General Neurologist",
            "Pediatric Neurologist",
            "Neurosurgeon",
            "Stroke Specialist",
            "Epilepsy Specialist",
            "Movement Disorders Specialist",
            "Neuro-oncologist"
        ],
        "Orthopedics": [
            "General Orthopedic Surgeon",
            "Sports Medicine Specialist",
            "Joint Replacement Surgeon",
            "Spine Surgeon",
            "Pediatric Orthopedist",
            "Hand Surgeon",
            "Foot & Ankle Specialist",
            "Trauma Surgeon"
        ],
        "Pediatrics": [
            "General Pediatrician",
            "Neonatologist",
            "Pediatric Cardiologist",
            "Pediatric Neurologist",
            "Pediatric Oncologist",
            "Pediatric Endocrinologist",
            "Pediatric Pulmonologist",
            "Developmental Pediatrician"
        ],
        "Gynecology & Obstetrics": [
            "General Obstetrician/Gynecologist",
            "Maternal-Fetal Medicine Specialist",
            "Reproductive Endocrinologist",
            "Gynecologic Oncologist",
            "Urogynecologist",
            "High-Risk Pregnancy Specialist"
        ],
        "Oncology": [
            "Medical Oncologist",
            "Radiation Oncologist",
            "Surgical Oncologist",
            "Pediatric Oncologist",
            "Hematologic Oncologist",
            "Neuro-oncologist",
            "Gynecologic Oncologist"
        ],
        "Radiology": [
            "Diagnostic Radiologist",
            "Interventional Radiologist",
            "Neuroradiologist",
            "Pediatric Radiologist",
            "Nuclear Medicine Specialist",
            "Musculoskeletal Radiologist",
            "Breast Imaging Specialist"
        ],
        "Emergency & Trauma": [
            "Emergency Medicine Physician",
            "Trauma Surgeon",
            "Pediatric Emergency Specialist",
            "Emergency Critical Care Specialist",
            "Toxicologist",
            "Disaster Medicine Specialist"
        ],
        "Dermatology": [
            "General Dermatologist",
            "Pediatric Dermatologist",
            "Dermatologic Surgeon",
            "Cosmetic Dermatologist",
            "Immunodermatologist",
            "Dermatopathologist"
        ],
        "Psychiatry": [
            "General Psychiatrist",
            "Child & Adolescent Psychiatrist",
            "Geriatric Psychiatrist",
            "Addiction Psychiatrist",
            "Forensic Psychiatrist",
            "Neuropsychiatrist"
        ],
        "Gastroenterology": [
            "General Gastroenterologist",
            "Hepatologist",
            "Pediatric Gastroenterologist",
            "Therapeutic Endoscopist",
            "Inflammatory Bowel Disease Specialist",
            "Pancreaticobiliary Specialist"
        ],
        "Nephrology": [
            "General Nephrologist",
            "Pediatric Nephrologist",
            "Transplant Nephrologist",
            "Dialysis Specialist",
            "Hypertension Specialist"
        ],
        "Endocrinology": [
            "General Endocrinologist",
            "Pediatric Endocrinologist",
            "Thyroid Specialist",
            "Diabetes Specialist",
            "Reproductive Endocrinologist",
            "Metabolic Disorders Specialist"
        ],
        "Pulmonology": [
            "General Pulmonologist",
            "Pediatric Pulmonologist",
            "Critical Care Pulmonologist",
            "Sleep Medicine Specialist",
            "Interventional Pulmonologist",
            "Cystic Fibrosis Specialist"
        ],
        "Ophthalmology": [
            "General Ophthalmologist",
            "Pediatric Ophthalmologist",
            "Retina Specialist",
            "Glaucoma Specialist",
            "Cornea Specialist",
            "Oculoplastic Surgeon",
            "Neuro-ophthalmologist"
        ],
        "ENT (Ear, Nose, Throat)": [
            "General ENT Specialist",
            "Pediatric ENT Specialist",
            "Otologist/Neurotologist",
            "Head & Neck Surgeon",
            "Laryngologist",
            "Rhinologist",
            "Facial Plastic Surgeon"
        ],
        "Urology": [
            "General Urologist",
            "Pediatric Urologist",
            "Urologic Oncologist",
            "Female Urologist",
            "Neurourologist",
            "Endourologist",
            "Reconstructive Urologist"
        ],
        "Anesthesiology": [
            "General Anesthesiologist",
            "Pediatric Anesthesiologist",
            "Cardiac Anesthesiologist",
            "Obstetric Anesthesiologist",
            "Pain Management Specialist",
            "Critical Care Anesthesiologist",
            "Regional Anesthesia Specialist"
        ],
        "Pathology & Lab Medicine": [
            "Anatomic Pathologist",
            "Clinical Pathologist",
            "Hematopathologist",
            "Dermatopathologist",
            "Cytopathologist",
            "Molecular Pathologist",
            "Forensic Pathologist",
            "Blood Bank/Transfusion Medicine Specialist"
        ]
    ]

    private let weekDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    private var maxYearsOfExperience: Int {
        guard let birthDate = dateOfBirth else {
            return 0 // Return 0 if no date of birth is selected
        }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        let age = ageComponents.year ?? 0
        return max(0, age - 25) // Maximum experience is age minus 25 years (medical school)
    }

    private var availableYearsOfExperience: [Int] {
        Array(0...maxYearsOfExperience)
    }

    // Add computed property for available specializations
    private var availableSpecializations: [String] {
        guard !department.isEmpty else { return [] }
        return departmentSpecializations[department] ?? []
    }

    private func validateForm() -> Bool {
        var isValid = true

        // First Name Validation
        if firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            firstNameError = "First name is required"
            isValid = false
        } else if firstName.count < 2 {
            firstNameError = "First name must be at least 2 characters"
            isValid = false
        } else if firstName.count > 50 {
            firstNameError = "First name must be less than 50 characters"
            isValid = false
        } else {
            firstNameError = ""
        }

        // Last Name Validation (optional but if provided, must be valid)
        if !lastName.isEmpty {
            if lastName.count < 2 {
                lastNameError = "Last name must be at least 2 characters"
            isValid = false
            } else if lastName.count > 50 {
                lastNameError = "Last name must be less than 50 characters"
                isValid = false
            } else {
                lastNameError = ""
            }
        }

        // Contact Number Validation
        if contactNumber.isEmpty {
            contactNumberError = "Contact number is required"
            isValid = false
        } else if !isValidPhoneNumber(contactNumber) {
            contactNumberError = "Please enter a valid phone number"
            isValid = false
        } else {
            contactNumberError = ""
        }

        // Email Validation
        if email.isEmpty {
            emailError = "Email is required"
            isValid = false
        } else if !isValidEmail(email) {
            emailError = "Please enter a valid email address"
            isValid = false
        } else {
            emailError = ""
        }

        // Date of Birth Validation
        if dateOfBirth == nil {
            isValid = false // Form is invalid if date not selected
        }

        // Medical License Number Validation
        if medicalLicenseNumber.isEmpty {
            medicalLicenseError = "Medical license number is required"
            isValid = false
        } else {
            medicalLicenseError = ""
        }

        // Consultation Fee Validation
        if consultationFee.isEmpty {
            consultationFeeError = "Consultation fee is required"
                isValid = false
            } else if let fee = Double(consultationFee) {
            if fee <= 0 {
                consultationFeeError = "Consultation fee must be greater than 0"
                    isValid = false
            } else if fee > 10000 {
                consultationFeeError = "Consultation fee must be less than 10,000"
                isValid = false
            } else {
                consultationFeeError = ""
                }
            } else {
            consultationFeeError = "Please enter a valid amount"
                isValid = false
        }

        // Department Validation
        if department.isEmpty {
            isValid = false
        }

        // Specialization Validation
        if specialization.isEmpty {
            isValid = false
        }

        return isValid
    }

    private func isValidPhoneNumber(_ phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: phone)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func checkFormValidity() {
        isFormValid = validateForm()
    }

    @State private var showingSuccessView = false
    @State private var savedDoctor: Staff?

    private func saveDoctor() {
        // Parse specializations correctly - they're already comma-separated from the multi-selection
        let specializations = specialization.trimmingCharacters(in: .whitespacesAndNewlines)
        let fee = Double(consultationFee) ?? 0.0

        // Create working hours object
        let workingHours = WorkingHours(
            startTime: startTime,
            endTime: endTime
        )

        // Validate all fields
        if !validateForm() || !isFormValid {
            return
        }

        isLoading = true

        if let existingDoctor = doctor {
            // Update existing doctor
            var updatedDoctor = existingDoctor
            updatedDoctor.firstName = firstName
            updatedDoctor.lastName = lastName
            updatedDoctor.emailAddress = email
            updatedDoctor.contactNumber = contactNumber
            updatedDoctor.dateOfBirth = dateOfBirth ?? Date()
            updatedDoctor.gender = selectedGender
            updatedDoctor.licenseId = medicalLicenseNumber
            updatedDoctor.yearOfExperience = yearsOfExperience
            updatedDoctor.consultationFee = Int(fee)
            updatedDoctor.department = department
            updatedDoctor.specialization = specializations
            updatedDoctor.workingHours = workingHours

            Task {
                let success = await DataController.shared.updateDoctor(updatedDoctor)
                if success {
                    dismiss()
                }
            }
        } else {
            // Generate a secure random password
            let password = generateRandomPassword()

            // Create new doctor
            var newDoctor = Staff(
                firstName: firstName,
                lastName: lastName,
                emailAddress: email,
                dateOfBirth: dateOfBirth ?? Date(),
                password: password,
                contactNumber: contactNumber,
                specialization: specializations,
                department: department,
                onLeave: false,
                consultationFee: Int(fee),
                licenseId: medicalLicenseNumber,
                yearOfExperience: yearsOfExperience,
                role: .doctor,
                hospitalId: DataController.shared.hospital?.id ?? ""
            )

            // Add working hours separately
            newDoctor.workingHours = workingHours

            Task {
                guard let savedDoctor = await DataController.shared.addDoctor(newDoctor) else {
                    isLoading = false
                    return
                }

                // Store the saved doctor before resetting the form
                self.savedDoctor = savedDoctor
                
                // Send welcome email
                printEmail(to: email, name: "\(firstName) \(lastName)", password: password)
                
                // Show success view
                showingSuccessView = true
                isLoading = false
            }
        }
    }

    // Generates a secure random password
    private func generateRandomPassword() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbers = "0123456789"
        let specialChars = "!@#$%^&*"
        let allChars = letters + numbers + specialChars

        var password = ""

        // Add at least one uppercase, lowercase, number and special char
        password += String(letters.uppercased().randomElement()!)
        password += String(letters.lowercased().randomElement()!)
        password += String(numbers.randomElement()!)
        password += String(specialChars.randomElement()!)

        // Add 6 more random chars for a total of 10 chars
        for _ in 0..<6 {
            password += String(allChars.randomElement()!)
        }

        // Shuffle the password to make it more random
        return String(password.shuffled())
    }

    private func printEmail(to email: String, name: String, password: String) {
        print("EMAIL SENT TO: \(email)")
        print("SUBJECT: Welcome to HMS - Your Doctor Account")
        print("BODY:")
        print("Dear Dr. \(name),")
        print("")
        print("Welcome to the Hospital Management System (HMS). Your account has been created by the administrator.")
        print("")
        print("Here are your login credentials:")
        print("Email: \(email)")
        print("Password: \(password)")
        print("")
        print("For security reasons, please change your password after your first login.")
        print("")
        print("Best regards,")
        print("The HMS Team")
    }

    private func resetForm() {
        // Reset all form fields
        firstName = ""
        lastName = ""
        contactNumber = ""
        email = ""
        dateOfBirth = nil
        selectedGender = .male
        medicalLicenseNumber = ""
        yearsOfExperience = 0
        consultationFee = ""
        department = ""
        specialization = ""
        selectedSpecializations = []
        startTime = Calendar.current.date(from: DateComponents(hour: 9, minute: 0)) ?? Date()
        endTime = Calendar.current.date(from: DateComponents(hour: 17, minute: 0)) ?? Date()
        selectedDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
        
        // Reset validation states
        firstNameError = ""
        lastNameError = ""
        contactNumberError = ""
        emailError = ""
        dateOfBirthError = ""
        medicalLicenseError = ""
        yearsOfExperienceError = ""
        consultationFeeError = ""
        departmentError = ""
        specializationError = ""
        
        // Reset interaction states
        dateOfBirthHasInteracted = false
        departmentHasInteracted = false
        specializationHasInteracted = false
        
        // Reset form validity
        checkFormValidity()
    }
}

// Custom GroupBox Style
struct CustomGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            configuration.content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Section Header View
struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(Color("iconBlue"))
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.bottom, 5)
    }
}

// Updated GenderButton
struct GenderButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(isSelected ? .semibold : .regular)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundColor(isSelected ? .white : .gray)
                .background(isSelected ? Color.blue : Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isSelected ? Color.blue : Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Success View
struct DoctorSuccessView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showCheckmark = false
    @State private var showContent = false
    @State private var showButtons = false
    
    let doctor: Staff
    var onGoToHome: (() -> Void)?
    var onAddAnotherDoctor: (() -> Void)?
    
    // MARK: - Haptics
    private func successHaptic() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func buttonHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Success checkmark
            ZStack {
                Circle()
                    .fill(Color.green)
                    .frame(width: 100, height: 100)
                    .shadow(color: .green.opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(showCheckmark ? 1 : 0.5)
            .opacity(showCheckmark ? 1 : 0)
            .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.2), value: showCheckmark)
            
            // Success text and Doctor card
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Doctor Added Successfully!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                    
                    Text("The doctor has been added to the hospital system")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                SuccessDoctorCard(doctor: doctor)
            }
            .opacity(showContent ? 1 : 0)
            .offset(y: showContent ? 0 : 20)
            .animation(.easeOut(duration: 0.4).delay(0.3), value: showContent)
            
            Spacer()
            
            // Buttons
            VStack(spacing: 16) {
                Button {
                    buttonHaptic()
                    onGoToHome?()
                } label: {
                    HStack {
                        Image(systemName: "house.fill")
                        Text("Go to Home")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.blue)
                    .cornerRadius(14)
                    .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                
                Button {
                    buttonHaptic()
                    onAddAnotherDoctor?()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Another Doctor")
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.white)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                }
            }
            .padding(.bottom, 16)
            .opacity(showButtons ? 1 : 0)
            .offset(y: showButtons ? 0 : 30)
            .animation(.easeOut(duration: 0.4).delay(0.5), value: showButtons)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            Task { @MainActor in
                successHaptic()
                withAnimation {
                    showCheckmark = true
                }
                try? await Task.sleep(for: .milliseconds(300))
                withAnimation {
                    showContent = true
                }
                try? await Task.sleep(for: .milliseconds(300))
                withAnimation {
                    showButtons = true
                }
            }
        }
    }
}

struct SuccessDoctorCard: View {
    let doctor: Staff
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Doctor info header
            HStack(spacing: 12) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.gray)
                    .background(Color.white)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(doctor.fullName)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text(doctor.specialization)
                        .foregroundColor(.secondary)
                }
            }
            
            // Department
            HStack(spacing: 12) {
                Image(systemName: "building.2.fill")
                    .foregroundColor(.gray)
                Text(doctor.department)
                    .foregroundColor(.secondary)
            }
            
            // Email
            HStack(spacing: 12) {
                Image(systemName: "envelope.fill")
                    .foregroundColor(.gray)
                Text(doctor.emailAddress)
                    .foregroundColor(.secondary)
            }
            
            // Phone
            HStack(spacing: 12) {
                Image(systemName: "phone.fill")
                    .foregroundColor(.gray)
                Text(doctor.contactNumber)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}
