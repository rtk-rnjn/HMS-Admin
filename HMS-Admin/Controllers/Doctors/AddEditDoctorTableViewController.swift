//
//  AddEditDoctorTableViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 21/03/25.
//

import UIKit

class AddEditDoctorTableViewController: UITableViewController {

    // MARK: Internal

    var doctor: Staff?

    @IBOutlet var dateOfBirthDatePicker: UIDatePicker!
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var contactNumberTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var medicalLicenseNumberTextField: UITextField!
    @IBOutlet var yearOfExperienceTextField: UITextField!
    @IBOutlet var specializationTextField: UITextField!
    @IBOutlet var departmentTextField: UITextField!

    var selectedGender: String = "Male"

    override func viewDidLoad() {
        super.viewDidLoad()

        dateOfBirthDatePicker.maximumDate = Date()

        prepareStaffIfPossible()
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Discard Changes?", message: "Are you sure you want to discard changes?", preferredStyle: .actionSheet)
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(discardAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func genderSegmentedControl(_ sender: UISegmentedControl) {
        selectedGender = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? "Other"
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard validateFields() else { return }

        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let dateOfBirth = dateOfBirthDatePicker.date
        let contactNumber = contactNumberTextField.text!
        let email = emailTextField.text!

        let gender = Gender(rawValue: selectedGender) ?? .other

        let medicalLicenseNumber = medicalLicenseNumberTextField.text!
        let yearOfExperience = Int(yearOfExperienceTextField.text!)!
        let specialization = specializationTextField.text!.components(separatedBy: ", ")
        let department = departmentTextField.text!

        let randomPassword = Utils.randomString(length: 8)

        let staff = Staff(firstName: firstName, lastName: lastName, gender: gender, emailAddress: email, dateOfBirth: dateOfBirth, password: randomPassword, contactNumber: contactNumber, specializations: specialization, department: department, licenseId: medicalLicenseNumber, yearOfExperience: yearOfExperience)

        Task {
            _ = await DataController.shared.addDoctor(staff)
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }

    // MARK: Private

    private func prepareStaffIfPossible() {
        firstNameField.text = doctor?.firstName
        lastNameField.text = doctor?.lastName
        dateOfBirthDatePicker.date = doctor?.dateOfBirth ?? Date()
        contactNumberTextField.text = doctor?.contactNumber
        emailTextField.text = doctor?.emailAddress
        medicalLicenseNumberTextField.text = doctor?.licenseId
        yearOfExperienceTextField.text = "\(doctor?.yearOfExperience ?? 0)"
        specializationTextField.text = doctor?.specializations.joined(separator: ", ")
        departmentTextField.text = doctor?.department
    }

    private func validateFields() -> Bool {
        guard let firstName = firstNameField.text, !firstName.isEmpty else {
            showAlert(message: "First name is required")
            return false
        }

        guard let lastName = lastNameField.text, !lastName.isEmpty else {
            showAlert(message: "Last name is required")
            return false
        }

        guard let contactNumber = contactNumberTextField.text, !contactNumber.isEmpty else {
            showAlert(message: "Contact number is required")
            return false
        }

        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Email is required")
            return false
        }

        guard let medicalLicenseNumber = medicalLicenseNumberTextField.text, !medicalLicenseNumber.isEmpty else {
            showAlert(message: "Medical license number is required")
            return false
        }

        let age = Calendar.current.dateComponents([.year], from: dateOfBirthDatePicker.date, to: Date()).year!

        guard let yearOfExperience = yearOfExperienceTextField.text, !yearOfExperience.isEmpty, let year = Int(yearOfExperience), year <= age else {
            showAlert(message: "Year of experience is required or invalid")
            return false
        }

        guard let specialization = specializationTextField.text, !specialization.isEmpty else {
            showAlert(message: "Specialization is required")
            return false
        }

        guard let department = departmentTextField.text, !department.isEmpty else {
            showAlert(message: "Department is required")
            return false
        }

        return true
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
