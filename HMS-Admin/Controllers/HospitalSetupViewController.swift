//
//  HospitalSetupViewController.swift
//  HMS-Admin
//
//  Created by Suryansh Srivastav on 28/03/25.
//

import Foundation
import UIKit

class HospitalSetupViewController: UIViewController {
    
    // MARK: - Properties
    var hospitalName: String = ""
    var address: String = ""
    var contact: String = ""
    var licenseNumber: String = ""
    var departments: [String] = []
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var hospitalNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Hospital Name"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.delegate = self
        return textField
    }()
    
    private lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Address"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.delegate = self
        return textField
    }()
    
    private lazy var contactTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Contact"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.keyboardType = .phonePad
        textField.delegate = self
        return textField
    }()
    
    private lazy var addDepartmentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Departments", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.contentHorizontalAlignment = .left
        button.backgroundColor = UIColor.systemGray5
        button.setTitleColor(.darkText, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Add right chevron image
        let chevronImage = UIImage(systemName: "chevron.right")
        let imageView = UIImageView(image: chevronImage)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        button.addSubview(imageView)
        
        // Position the chevron on the right side
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -15),
            imageView.widthAnchor.constraint(equalToConstant: 15),
            imageView.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        // Add left padding for text
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        
        button.addTarget(self, action: #selector(addDepartmentsTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var licenseNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "License Number"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.delegate = self
        return textField
    }()
    
    private lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor.systemGray6
        
        // Add scroll view
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add UI elements to content view
        contentView.addSubview(hospitalNameTextField)
        contentView.addSubview(addressTextField)
        contentView.addSubview(contactTextField)
        contentView.addSubview(addDepartmentsButton)
        contentView.addSubview(licenseNumberTextField)
        contentView.addSubview(completeButton)
        
        // Set constraints
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Hospital name field
            hospitalNameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            hospitalNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            hospitalNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            hospitalNameTextField.heightAnchor.constraint(equalToConstant: 55),
            
            // Address field
            addressTextField.topAnchor.constraint(equalTo: hospitalNameTextField.bottomAnchor, constant: 20),
            addressTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addressTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addressTextField.heightAnchor.constraint(equalToConstant: 55),
            
            // Contact field
            contactTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 20),
            contactTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contactTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contactTextField.heightAnchor.constraint(equalToConstant: 55),
            
            // Add departments button
            addDepartmentsButton.topAnchor.constraint(equalTo: contactTextField.bottomAnchor, constant: 20),
            addDepartmentsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addDepartmentsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addDepartmentsButton.heightAnchor.constraint(equalToConstant: 55),
            
            // License number field
            licenseNumberTextField.topAnchor.constraint(equalTo: addDepartmentsButton.bottomAnchor, constant: 20),
            licenseNumberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            licenseNumberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            licenseNumberTextField.heightAnchor.constraint(equalToConstant: 55),
            
            // Complete button
            completeButton.topAnchor.constraint(equalTo: licenseNumberTextField.bottomAnchor, constant: 30),
            completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            completeButton.heightAnchor.constraint(equalToConstant: 55),
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavigationBar() {
        title = "Hospital Setup"
        
        // Left button - Back
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back", 
            style: .plain, 
            target: self, 
            action: #selector(backButtonTapped)
        )
    }
    
    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addDepartmentsTapped() {
        // Navigate to departments selection screen or show department selection UI
        let departmentsVC = DepartmentsViewController()
        departmentsVC.selectedDepartments = departments
        departmentsVC.onDepartmentSelectionComplete = { [weak self] selectedDepartments in
            self?.departments = selectedDepartments
            self?.validateForm()
        }
        navigationController?.pushViewController(departmentsVC, animated: true)
    }
    
    @objc private func completeButtonTapped() {
        if validateForm() {
            saveHospitalInfo()
            
            // Navigate to success screen
            let successVC = HospitalSuccessViewController()
            successVC.hospitalName = hospitalName
            successVC.address = address
            successVC.contactNumber = contact
            successVC.licenseNumber = licenseNumber
            navigationController?.pushViewController(successVC, animated: true)
        }
    }
    
    private func textFieldDidChange(_ textField: UITextField) {
        // Update model properties
        if textField == hospitalNameTextField {
            hospitalName = textField.text ?? ""
        } else if textField == addressTextField {
            address = textField.text ?? ""
        } else if textField == contactTextField {
            contact = textField.text ?? ""
            formatPhoneNumber(textField)
        } else if textField == licenseNumberTextField {
            licenseNumber = textField.text ?? ""
        }
        
        validateForm()
    }
    
    private func formatPhoneNumber(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        // Remove non-numeric characters
        let numericText = text.filter { $0.isNumber }
        
        // Limit to 10 digits
        let truncatedText = String(numericText.prefix(10))
        
        // Format number
        contact = truncatedText
        
        switch truncatedText.count {
        case 0...3:
            textField.text = truncatedText
        case 4...6:
            textField.text = "(\(truncatedText.prefix(3))) \(truncatedText.dropFirst(3))"
        case 7...10:
            textField.text = "(\(truncatedText.prefix(3))) \(truncatedText.dropFirst(3).prefix(3))-\(truncatedText.dropFirst(6))"
        default:
            textField.text = truncatedText
        }
    }
    
    private func saveHospitalInfo() {
        // Create hospital object
        let hospital = Hospital(
            name: hospitalName,
            address: address,
            contact: contact,
            departments: departments,
            adminId: DataController.shared.admin?.id ?? ""
        )
        
        // Save to data controller (assuming this implementation exists)
        // DataController.shared.saveHospitalInfo(hospital)
        
        print("Hospital saved: \(hospital.name)")
    }
    
    private func validateForm() -> Bool {
        // Check if all required fields are filled
        let isHospitalNameValid = !hospitalName.isEmpty
        let isAddressValid = !address.isEmpty
        let isContactValid = contact.count >= 10
        let isLicenseNumberValid = !licenseNumber.isEmpty
        let hasDepartments = !departments.isEmpty
        
        let isValid = isHospitalNameValid && isAddressValid && isContactValid && isLicenseNumberValid && hasDepartments
        
        // Update button state
        completeButton.isEnabled = isValid
        completeButton.alpha = isValid ? 1.0 : 0.5
        
        return isValid
    }
}

// MARK: - UITextFieldDelegate
extension HospitalSetupViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textFieldDidChange(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textFieldDidChange(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Handle keyboard return key
        switch textField {
        case hospitalNameTextField:
            addressTextField.becomeFirstResponder()
        case addressTextField:
            contactTextField.becomeFirstResponder()
        case contactTextField:
            licenseNumberTextField.becomeFirstResponder()
        case licenseNumberTextField:
            textField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}

// MARK: - DepartmentsViewController
class DepartmentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedDepartments: [String] = []
    var onDepartmentSelectionComplete: (([String]) -> Void)?
    
    private let allDepartments = [
        "Emergency Medicine", "Cardiology", "Neurology", "Orthopedics",
        "Pediatrics", "Oncology", "Ophthalmology", "Dermatology",
        "Gastroenterology", "Urology", "Psychiatry", "Radiology"
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "departmentCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Select Departments"
        view.backgroundColor = .systemGroupedBackground
        
        // Add save button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveDepartments)
        )
        
        // Add table view
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func saveDepartments() {
        onDepartmentSelectionComplete?(selectedDepartments)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDepartments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "departmentCell", for: indexPath)
        let department = allDepartments[indexPath.row]
        
        cell.textLabel?.text = department
        
        // Check if department is selected
        if selectedDepartments.contains(department) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let department = allDepartments[indexPath.row]
        
        if let index = selectedDepartments.firstIndex(of: department) {
            // Remove if already selected
            selectedDepartments.remove(at: index)
        } else {
            // Add if not selected
            selectedDepartments.append(department)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
} 
