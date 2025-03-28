//
//  AddDoctorView.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import SwiftUI

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
            _specialization = State(initialValue: doctor.specializations.joined(separator: ", "))
        }
    }

    // MARK: Internal

    var delegate: AddDoctorHostingController?
//    @EnvironmentObject var doctorStore: DoctorStore

    let doctor: Staff?
    // Dropdown data
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

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 20) {
                        // Personal Information Section
                        GroupBox {
                            VStack(alignment: .leading, spacing: 15) {
                                Label("Personal Information", systemImage: "person.fill")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.bottom, 5)

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
                                    keyboardType: .phonePad,
                                    onChange: { _ in
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
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Date of Birth")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    DatePicker("", selection: $dateOfBirth, in: ...Date(), displayedComponents: .date)
                                        .labelsHidden()
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(dateOfBirthError.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                                        )
                                        .onChange(of: dateOfBirth) { _ in
                                            dateOfBirthError = ""
                                        }

                                    if !dateOfBirthError.isEmpty {
                                        Text(dateOfBirthError)
                                            .font(.footnote)
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 4)
                                    }
                                }

                                // Gender Selection
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Gender")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    HStack(spacing: 0) {
                                        GenderButton(title: "Male", isSelected: selectedGender == .male) {
                                            selectedGender = .male
                                        }

                                        GenderButton(title: "Female", isSelected: selectedGender == .female) {
                                            selectedGender = .female
                                        }

                                        GenderButton(title: "Other", isSelected: selectedGender == .other) {
                                            selectedGender = .other
                                        }
                                    }
                                    .background(Color.white)
                                    .cornerRadius(8)
                                }
                            }
                        }

                        // Professional Information Section
                        GroupBox {
                            VStack(alignment: .leading, spacing: 15) {
                                Label("Professional Information", systemImage: "stethoscope")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.bottom, 5)

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
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Years of Experience")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Menu {
                                        Picker("Years of Experience", selection: $yearsOfExperience) {
                                            ForEach(0...65, id: \.self) { year in
                                                Text("\(year) years").tag(year)
                                            }
                                        }
                                    } label: {
                                        HStack {
                                            Text("\(yearsOfExperience) years")
                                                .foregroundColor(.black)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .foregroundColor(.gray)
                                        }
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(yearsOfExperienceError.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                                        )
                                    }

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

                        // Department & Specializations Section
                        GroupBox {
                            VStack(alignment: .leading, spacing: 15) {
                                Label("Department & Specializations", systemImage: "building.2")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.bottom, 5)

                                // Department
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Department")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Menu {
                                        ForEach(departments, id: \.self) { dept in
                                            Button(action: {
                                                department = dept
                                                departmentError = ""
                                                checkFormValidity()
                                            }) {
                                                HStack {
                                                    Text(dept)
                                                    if department == dept {
                                                        Image(systemName: "checkmark")
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
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(departmentError.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                                        )
                                    }

                                    if !departmentError.isEmpty {
                                        Text(departmentError)
                                            .font(.footnote)
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 4)
                                    }
                                }

                                // Specializations
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Specializations")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Button(action: {
                                        showingSpecializationDropdown = true
                                    }) {
                                        HStack {
                                            if specialization.isEmpty {
                                                Text("Select Specializations")
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
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(specializationError.isEmpty ? Color.clear : Color.red, lineWidth: 1)
                                        )
                                    }

                                    if !specializationError.isEmpty {
                                        Text(specializationError)
                                            .font(.footnote)
                                            .foregroundColor(.red)
                                            .padding(.horizontal, 4)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .sheet(isPresented: $showingSpecializationDropdown) {
                NavigationView {
                    List(selection: $selectedSpecializations) {
                        ForEach(specializations, id: \.self) { spec in
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
                    selectedSpecializations = Set(
                        specialization.split(separator: ",")
                            .map { String($0.trimmingCharacters(in: .whitespaces)) }
                            .filter { !$0.isEmpty }
                    )
                }
            }
            .navigationTitle(doctor == nil ? "Add Doctor" : "Edit Doctor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if validateForm() {
                        saveDoctor()
                        } else {
                            showingValidationAlert = true
                        }
                    }
                    .foregroundColor(isFormValid ? .blue : Color.blue.opacity(0.5))
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
            .alert(isPresented: $showingValidationAlert) {
                Alert(
                    title: Text("Validation Error"),
                    message: Text(validationMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            }
            .onAppear {
            checkFormValidity()
        }
        .onChange(of: firstName) { _ in checkFormValidity() }
        .onChange(of: lastName) { _ in checkFormValidity() }
        .onChange(of: contactNumber) { _ in checkFormValidity() }
        .onChange(of: email) { _ in checkFormValidity() }
        .onChange(of: medicalLicenseNumber) { _ in checkFormValidity() }
        .onChange(of: consultationFee) { _ in checkFormValidity() }
        .onChange(of: department) { _ in checkFormValidity() }
        .onChange(of: specialization) { _ in checkFormValidity() }
        .onChange(of: yearsOfExperience) { _ in checkFormValidity() }
    }

    // MARK: Private

    @Environment(\.dismiss) private var dismiss

    // Personal Information
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var contactNumber = ""
    @State private var email = ""
    @State private var dateOfBirth: Date = .init()
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
    @State private var showingDepartmentDropdown = false
    @State private var showingSpecializationDropdown = false
    @State private var selectedSpecializations: Set<String> = []

    // Form validation
    @State private var showingValidationAlert = false
    @State private var validationMessage = ""
    @State private var isFormValid = false

    private func validateForm() -> Bool {
        // Reset all error messages
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

        var isValid = true

        // First Name validation
        if firstName.isEmpty {
            firstNameError = "First name is required"
            isValid = false
        } else if !firstName.allSatisfy({ $0.isLetter || $0.isWhitespace }) {
            firstNameError = "First name should contain only letters and spaces"
            isValid = false
        }

        // Last Name validation
        if !lastName.isEmpty && !lastName.allSatisfy({ $0.isLetter || $0.isWhitespace }) {
            lastNameError = "Last name should contain only letters and spaces"
            isValid = false
        }

        // Contact Number validation
        if contactNumber.isEmpty {
            contactNumberError = "Contact number is required"
            isValid = false
        } else if !contactNumber.allSatisfy({ $0.isNumber || $0 == "+" || $0 == " " || $0 == "-" || $0 == "(" || $0 == ")" }) {
            contactNumberError = "Contact number should contain only digits, +, -, spaces, or parentheses"
            isValid = false
        } else {
            // Strip all non-numeric characters and check length
            let numericOnly = contactNumber.filter { $0.isNumber }
            if numericOnly.count < 10 || numericOnly.count > 15 {
                contactNumberError = "Contact number should have 10-15 digits"
                isValid = false
            }
        }

        // Email validation
        if email.isEmpty {
            emailError = "Email is required"
            isValid = false
        } else if !isValidEmail(email) {
            emailError = "Please enter a valid email address"
            isValid = false
        }

        // Date of Birth validation
        if dateOfBirth > Date() {
            dateOfBirthError = "Date of birth cannot be in the future"
            isValid = false
        }

        // Calculate age
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        let age = ageComponents.year ?? 0

        // Medical License validation
        if medicalLicenseNumber.isEmpty {
            medicalLicenseError = "Medical license number is required"
            isValid = false
        } else if medicalLicenseNumber.count < 6 {
            medicalLicenseError = "Medical license number should be at least 6 characters"
            isValid = false
        } else if !medicalLicenseNumber.allSatisfy({ $0.isLetter || $0.isNumber || $0 == "-" }) {
            medicalLicenseError = "Medical license should contain only letters, numbers, and hyphens"
            isValid = false
        }

        // Years of Experience validation
        if yearsOfExperience > 65 {
            yearsOfExperienceError = "Years of experience cannot exceed 65 years"
            isValid = false
        }

        // Consultation Fee validation
        if consultationFee.isEmpty {
            consultationFeeError = "Consultation fee is required"
            isValid = false
        } else {
            // Ensure the consultation fee has maximum 2 decimal places
            let components = consultationFee.components(separatedBy: ".")
            if components.count > 1 && components[1].count > 2 {
                consultationFeeError = "Consultation fee should have maximum 2 decimal places"
                isValid = false
            } else if let fee = Double(consultationFee) {
                if fee < 0 {
                    consultationFeeError = "Consultation fee cannot be negative"
                    isValid = false
                }
            } else {
                consultationFeeError = "Consultation fee must be a valid number"
                isValid = false
            }
        }

        // Department validation
        if department.isEmpty {
            departmentError = "Department is required"
            isValid = false
        } else if !departments.contains(department) {
            departmentError = "Please select a valid department from the list"
            isValid = false
        }

        // Specialization validation
        if specialization.isEmpty {
            specializationError = "At least one specialization is required"
            isValid = false
        }

        if !isValid {
            // Set the main validation message
            validationMessage = "Please correct the highlighted errors"
        }

        return isValid
    }

    private func checkFormValidity() {
        // This performs a light validation to enable/disable the save button
        // We only check if mandatory fields are filled, not detailed validation
        isFormValid = !firstName.isEmpty &&
                     !contactNumber.isEmpty &&
                     !email.isEmpty &&
                     isValidEmail(email) &&
                     !medicalLicenseNumber.isEmpty &&
                     !consultationFee.isEmpty &&
                     !department.isEmpty &&
                     !specialization.isEmpty
    }

    // Email validation helper
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func saveDoctor() {
        // Parse specializations correctly - they're already comma-separated from the multi-selection
        let specializations = specialization.split(separator: ",")
            .map { String($0.trimmingCharacters(in: .whitespaces)) }
            .filter { !$0.isEmpty }

        let fee = Double(consultationFee) ?? 0.0

        if let existingDoctor = doctor {
            // Update existing doctor
            var updatedDoctor = existingDoctor
            updatedDoctor.firstName = firstName
            updatedDoctor.lastName = lastName
            updatedDoctor.emailAddress = email
            updatedDoctor.contactNumber = contactNumber
            updatedDoctor.dateOfBirth = dateOfBirth
            updatedDoctor.gender = selectedGender
            updatedDoctor.licenseId = medicalLicenseNumber
            updatedDoctor.yearOfExperience = yearsOfExperience
            updatedDoctor.consultationFee = Int(fee)
            updatedDoctor.department = department
            updatedDoctor.specializations = specializations

//            doctorStore.updateDoctor(updatedDoctor)
            // Dismiss the view after update
            dismiss()
        } else {
            // Generate a secure random password
            let password = generateRandomPassword()

            // Create new doctor
            let newDoctor = Staff(
                firstName: firstName,
                lastName: lastName,
                emailAddress: email,
                dateOfBirth: dateOfBirth,
                password: password,
                contactNumber: contactNumber,
                specializations: specializations,
                department: department,
                onLeave: false,
                consultationFee: Int(fee),
                unavailabilityPeriods: [],
                licenseId: medicalLicenseNumber,
                yearOfExperience: yearsOfExperience,
                role: .doctor,
                hospitalId: DataController.shared.hospital?.id ?? ""
            )

            Task {
                guard let created = await DataController.shared.addDoctor(newDoctor) else {
                    return
                }

                printEmail(to: email, name: "\(firstName) \(lastName)", password: password)
                dismiss()

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
}

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
        }
        .buttonStyle(PlainButtonStyle())
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
