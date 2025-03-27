////
////  HospitalOnboardingViewController.swift
////  HMS-Admin
////
////  Created by Suryansh Srivastav on 28/03/25.
////
//
//import Foundation
//import UIKit
//
//class HospitalOnboardingViewController: UITableViewController {
//    
//    // MARK: - Properties
//    
//    // Hospital Details Section
//    var hospitalName: String = ""
//    var contactNumber: String = ""
//    var hospitalAddress: String = ""
//    
//    // License Details Section
//    var licenseNumber: String = ""
//    var validUntilDate: Date = Date().addingTimeInterval(60*60*24*365) // Default: 1 year from now
//    
//    // Departments Section
//    var departments: [String] = []
//    
//    // MARK: - UI Elements
//    
//    // Hospital Details Section
//    private lazy var hospitalNameTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter hospital name"
//        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.borderStyle = .none
//        textField.backgroundColor = .systemBackground
//        textField.layer.cornerRadius = 8
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemGray5.cgColor
//        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
//        textField.leftViewMode = .always
//        textField.textColor = .darkText
//        textField.attributedPlaceholder = NSAttributedString(
//            string: "Enter hospital name",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
//        )
//        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        return textField
//    }()
//    
//    private lazy var contactNumberTextField: UITextField = {
//        let textField = UITextField()
//        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.borderStyle = .none
//        textField.backgroundColor = .systemBackground
//        textField.layer.cornerRadius = 8
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemGray5.cgColor
//        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
//        textField.leftViewMode = .always
//        textField.keyboardType = .phonePad
//        textField.textColor = .darkText
//        textField.attributedPlaceholder = NSAttributedString(
//            string: "+1 (555) 000-0000",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
//        )
//        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        return textField
//    }()
//    
//    private lazy var hospitalAddressTextView: UITextView = {
//        let textView = UITextView()
//        textView.font = UIFont.systemFont(ofSize: 16)
//        textView.backgroundColor = .systemBackground
//        textView.layer.cornerRadius = 8
//        textView.layer.borderWidth = 1
//        textView.layer.borderColor = UIColor.systemGray5.cgColor
//        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
//        textView.text = "Enter complete address"
//        textView.textColor = UIColor.systemGray3
//        textView.delegate = self
//        return textView
//    }()
//    
//    // License Details Section
//    private lazy var licenseNumberTextField: UITextField = {
//        let textField = UITextField()
//        textField.font = UIFont.systemFont(ofSize: 16)
//        textField.borderStyle = .none
//        textField.backgroundColor = .systemBackground
//        textField.layer.cornerRadius = 8
//        textField.layer.borderWidth = 1
//        textField.layer.borderColor = UIColor.systemGray5.cgColor
//        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: textField.frame.height))
//        textField.leftViewMode = .always
//        textField.textColor = .darkText
//        textField.attributedPlaceholder = NSAttributedString(
//            string: "Enter license number",
//            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3]
//        )
//        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
//        return textField
//    }()
//    
//    private lazy var validUntilDatePicker: UIDatePicker = {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        datePicker.preferredDatePickerStyle = .inline
//        datePicker.minimumDate = Date() // Cannot be earlier than today
//        datePicker.tintColor = .systemBlue
//        
//        // Format to show yyyy/mm/dd
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy / MM / dd"
//        
//        // Create a text field look for the date picker
//        let containerView = UIView()
//        containerView.backgroundColor = .white
//        containerView.layer.borderWidth = 1
//        containerView.layer.borderColor = UIColor.systemGray5.cgColor
//        containerView.layer.cornerRadius = 8
//        
//        return datePicker
//    }()
//    
//    // Date picker label
//    private lazy var datePickerLabel: UILabel = {
//        let label = UILabel()
//        label.text = "yyyy / mm / dd"
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.textColor = .systemGray3
//        label.textAlignment = .center
//        return label
//    }()
//    
//    // Complete Button
//    private lazy var completeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Complete Onboarding", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        button.backgroundColor = .systemBlue
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 25
//        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
//        button.isEnabled = true
//        button.alpha = 1.0
//        return button
//    }()
//    
//    // MARK: - Lifecycle Methods
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupNavigationBar()
//        setupTableView()
//    }
//    
//    // MARK: - Setup
//    
//    private func setupNavigationBar() {
//        title = "Hospital Onboarding"
//        
//        // Left button - Back
//        navigationItem.leftBarButtonItem = UIBarButtonItem(
//            title: "Back", 
//            style: .plain, 
//            target: self, 
//            action: #selector(backButtonTapped)
//        )
//        
//        // Right button - Save
//        navigationItem.rightBarButtonItem = UIBarButtonItem(
//            title: "Save", 
//            style: .done, 
//            target: self, 
//            action: #selector(saveButtonTapped)
//        )
//    }
//    
//    private func setupTableView() {
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.register(TextFieldCell.self, forCellReuseIdentifier: "textFieldCell")
//        tableView.register(TextViewCell.self, forCellReuseIdentifier: "textViewCell")
//        tableView.register(DatePickerCell.self, forCellReuseIdentifier: "datePickerCell")
//        tableView.register(DepartmentCell.self, forCellReuseIdentifier: "departmentCell")
//        tableView.register(ButtonCell.self, forCellReuseIdentifier: "buttonCell")
//        
//        tableView.separatorStyle = .none
//        tableView.allowsSelection = true
//        tableView.keyboardDismissMode = .onDrag
//        
//        // Add tap gesture to dismiss keyboard
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tapGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapGesture)
//    }
//    
//    // MARK: - Action Methods
//    
//    @objc private func backButtonTapped() {
//        // Handle back button action - typically going back to previous screen
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @objc private func saveButtonTapped() {
//        // Save current progress without completing
//        saveHospitalInfo()
//        navigationController?.popViewController(animated: true)
//    }
//    
//    @objc private func textFieldDidChange(_ textField: UITextField) {
//        // Handle text field changes
//        if textField == contactNumberTextField {
//            formatPhoneNumber(textField)
//        }
//        validateForm()
//    }
//    
//    @objc private func datePickerValueChanged(_ datePicker: UIDatePicker) {
//        validUntilDate = datePicker.date
//        validateForm()
//    }
//    
//    @objc private func dismissKeyboard() {
//        view.endEditing(true)
//    }
//    
//    @objc private func addDepartmentTapped() {
//        // Show alert to add department
//        let alertController = UIAlertController(title: "Add Department", message: "Enter department name", preferredStyle: .alert)
//        
//        alertController.addTextField { textField in
//            textField.placeholder = "Department Name"
//        }
//        
//        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
//            guard let department = alertController.textFields?.first?.text, !department.isEmpty else { return }
//            self?.departments.append(department)
//            self?.tableView.reloadData()
//            self?.validateForm()
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
//        
//        alertController.addAction(addAction)
//        alertController.addAction(cancelAction)
//        
//        present(alertController, animated: true)
//    }
//    
//    @objc private func completeButtonTapped() {
//        if validateForm() {
//            saveHospitalInfo()
//            
//            // Use the segue defined in the storyboard
//            performSegue(withIdentifier: "segueToHospitalSuccess", sender: nil)
//        }
//    }
//    
//    // Add prepare for segue method to pass data to the success screen
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segueToHospitalSuccess", 
//           let successVC = segue.destination as? HospitalSuccessViewController {
//            // Pass hospital information
//            successVC.hospitalName = hospitalName
//            successVC.address = hospitalAddress
//            successVC.pinCode = contactNumber
//            successVC.licenseNumber = licenseNumber
//        }
//    }
//    
//    private func deleteDepartment(at index: Int) {
//        departments.remove(at: index)
//        tableView.reloadData()
//        validateForm()
//    }
//    
//    // MARK: - Helper Methods
//    
//    private func formatPhoneNumber(_ textField: UITextField) {
//        guard let text = textField.text else { return }
//        
//        // Remove non-numeric characters
//        let numericText = text.filter { $0.isNumber }
//        
//        // Limit to 10 digits
//        let truncatedText = String(numericText.prefix(10))
//        
//        // Format as (XXX) XXX-XXXX if we have enough digits
//        contactNumber = truncatedText
//        
//        switch truncatedText.count {
//        case 0...3:
//            textField.text = truncatedText
//        case 4...6:
//            textField.text = "(\(truncatedText.prefix(3))) \(truncatedText.dropFirst(3))"
//        case 7...10:
//            textField.text = "(\(truncatedText.prefix(3))) \(truncatedText.dropFirst(3).prefix(3))-\(truncatedText.dropFirst(6))"
//        default:
//            textField.text = truncatedText
//        }
//    }
//    
//    private func saveHospitalInfo() {
//        // Update model properties
//        hospitalName = hospitalNameTextField.text ?? ""
//        hospitalAddress = hospitalAddressTextView.text ?? ""
//        licenseNumber = licenseNumberTextField.text ?? ""
//        
//        // Save to data model
//        let hospital = Hospital(
//            name: hospitalName,
//            address: hospitalAddress,
//            contact: contactNumber,
//            departments: departments,
//            adminId: DataController.shared.admin?.id ?? ""
//        )
//        
//        // Save to data controller (assuming this implementation exists)
//        // DataController.shared.saveHospitalInfo(hospital)
//        
//        print("Hospital saved: \(hospital.name)")
//    }
//    
//    private func validateForm() -> Bool {
//        // Check if all required fields are filled
//        let isHospitalNameValid = !hospitalName.isEmpty
//        let isContactNumberValid = contactNumber.count == 10
//        let isHospitalAddressValid = !hospitalAddress.isEmpty
//        let isLicenseNumberValid = !licenseNumber.isEmpty
//        let hasAtLeastOneDepartment = !departments.isEmpty
//        
//        let isFormValid = isHospitalNameValid && isContactNumberValid && 
//                         isHospitalAddressValid && isLicenseNumberValid && hasAtLeastOneDepartment
//        
//        // Update button state
//        completeButton.isEnabled = isFormValid
//        completeButton.alpha = isFormValid ? 1.0 : 0.7
//        
//        return isFormValid
//    }
//    
//    // MARK: - TableView Data Source
//    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 4 // Hospital Details, License Details, Departments, Action Button
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0: // Hospital Details
//            return 3
//        case 1: // License Details
//            return 2
//        case 2: // Departments
//            return departments.count + 1 // Departments + Add Department button
//        case 3: // Action Button
//            return 1
//        default:
//            return 0
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0: // Hospital Details
//            switch indexPath.row {
//            case 0:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
//                cell.configure(with: "Hospital Name", textField: hospitalNameTextField)
//                return cell
//            case 1:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
//                cell.configure(with: "Contact Number", textField: contactNumberTextField)
//                return cell
//            case 2:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "textViewCell", for: indexPath) as! TextViewCell
//                cell.configure(with: "Hospital Address", textView: hospitalAddressTextView)
//                return cell
//            default:
//                return UITableViewCell()
//            }
//            
//        case 1: // License Details
//            switch indexPath.row {
//            case 0:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "textFieldCell", for: indexPath) as! TextFieldCell
//                cell.configure(with: "License Number", textField: licenseNumberTextField)
//                return cell
//            case 1:
//                let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell", for: indexPath) as! DatePickerCell
//                cell.configure(with: "Valid Until", datePicker: validUntilDatePicker)
//                return cell
//            default:
//                return UITableViewCell()
//            }
//            
//        case 2: // Departments
//            if indexPath.row < departments.count {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "departmentCell", for: indexPath) as! DepartmentCell
//                cell.configure(with: departments[indexPath.row]) { [weak self] in
//                    self?.deleteDepartment(at: indexPath.row)
//                }
//                return cell
//            } else {
//                // Add Department Button
//                let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as! ButtonCell
//                cell.configure(with: "+ Add Department") { [weak self] in
//                    self?.addDepartmentTapped()
//                }
//                return cell
//            }
//            
//        case 3: // Action Button
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
//            cell.selectionStyle = .none
//            
//            // Add complete button to cell
//            cell.contentView.addSubview(completeButton)
//            completeButton.translatesAutoresizingMaskIntoConstraints = false
//            NSLayoutConstraint.activate([
//                completeButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 16),
//                completeButton.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
//                completeButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
//                completeButton.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -16),
//                completeButton.heightAnchor.constraint(equalToConstant: 50)
//            ])
//            
//            return cell
//            
//        default:
//            return UITableViewCell()
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = .systemGroupedBackground
//        
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        label.textColor = .darkGray
//        
//        switch section {
//        case 0:
//            label.text = "Hospital Details"
//        case 1:
//            label.text = "License Details"
//        case 2:
//            label.text = "Departments"
//        default:
//            return nil
//        }
//        
//        headerView.addSubview(label)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
//            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -12),
//        ])
//        
//        return headerView
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 && indexPath.row == 2 {
//            return 120 // Height for text view cell
//        } else if indexPath.section == 3 {
//            return 82 // Height for action button
//        }
//        return UITableView.automaticDimension
//    }
//}
//
//// MARK: - UITextViewDelegate
//
//extension HospitalOnboardingViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.systemGray3 && textView.text == "Enter complete address" {
//            textView.text = ""
//            textView.textColor = .darkText
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Enter complete address"
//            textView.textColor = UIColor.systemGray3
//        }
//    }
//    
//    func textViewDidChange(_ textView: UITextView) {
//        if textView == hospitalAddressTextView {
//            if textView.textColor == UIColor.darkText {
//                hospitalAddress = textView.text
//                validateForm()
//            } else {
//                hospitalAddress = ""
//            }
//        }
//    }
//}
//
//// MARK: - Custom Cells
//
//class TextFieldCell: UITableViewCell {
//    private let titleLabel = UILabel()
//    private var textField: UITextField?
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//    
//    private func setupViews() {
//        selectionStyle = .none
//        
//        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(titleLabel)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//        ])
//    }
//    
//    func configure(with title: String, textField: UITextField) {
//        titleLabel.text = title
//        
//        // Remove previous text field if exists
//        self.textField?.removeFromSuperview()
//        
//        // Add new text field
//        self.textField = textField
//        if let textField = self.textField {
//            textField.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(textField)
//            
//            NSLayoutConstraint.activate([
//                textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//                textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//                textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//                textField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
//                textField.heightAnchor.constraint(equalToConstant: 44)
//            ])
//        }
//    }
//}
//
//class TextViewCell: UITableViewCell {
//    private let titleLabel = UILabel()
//    private var textView: UITextView?
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//    
//    private func setupViews() {
//        selectionStyle = .none
//        
//        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(titleLabel)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//        ])
//    }
//    
//    func configure(with title: String, textView: UITextView) {
//        titleLabel.text = title
//        
//        // Remove previous text view if exists
//        self.textView?.removeFromSuperview()
//        
//        // Add new text view
//        self.textView = textView
//        if let textView = self.textView {
//            textView.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview(textView)
//            
//            NSLayoutConstraint.activate([
//                textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//                textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//                textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//                textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
//                textView.heightAnchor.constraint(equalToConstant: 80)
//            ])
//        }
//    }
//}
//
//class DatePickerCell: UITableViewCell {
//    private let titleLabel = UILabel()
//    private var datePicker: UIDatePicker?
//    private let dateDisplayLabel = UILabel()
//    private let calendarIcon = UIImageView(image: UIImage(systemName: "calendar"))
//    private let dateContainer = UIView()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//    
//    private func setupViews() {
//        selectionStyle = .none
//        
//        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(titleLabel)
//        
//        // Date container
//        dateContainer.backgroundColor = .systemBackground
//        dateContainer.layer.cornerRadius = 8
//        dateContainer.layer.borderWidth = 1
//        dateContainer.layer.borderColor = UIColor.systemGray5.cgColor
//        dateContainer.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(dateContainer)
//        
//        // Date label
//        dateDisplayLabel.font = UIFont.systemFont(ofSize: 16)
//        dateDisplayLabel.text = "yyyy / mm / dd"
//        dateDisplayLabel.textColor = .systemGray3
//        dateDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
//        dateContainer.addSubview(dateDisplayLabel)
//        
//        // Calendar icon
//        calendarIcon.tintColor = .systemGray3
//        calendarIcon.contentMode = .scaleAspectFit
//        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
//        dateContainer.addSubview(calendarIcon)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
//            
//            dateContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            dateContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            dateContainer.heightAnchor.constraint(equalToConstant: 44),
//            dateContainer.widthAnchor.constraint(equalToConstant: 180),
//            
//            dateDisplayLabel.leadingAnchor.constraint(equalTo: dateContainer.leadingAnchor, constant: 16),
//            dateDisplayLabel.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor),
//            
//            calendarIcon.trailingAnchor.constraint(equalTo: dateContainer.trailingAnchor, constant: -16),
//            calendarIcon.centerYAnchor.constraint(equalTo: dateContainer.centerYAnchor),
//            calendarIcon.widthAnchor.constraint(equalToConstant: 20),
//            calendarIcon.heightAnchor.constraint(equalToConstant: 20)
//        ])
//    }
//    
//    func configure(with title: String, datePicker: UIDatePicker) {
//        titleLabel.text = title
//        
//        // Update date format
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy / MM / dd"
//        dateDisplayLabel.text = formatter.string(from: datePicker.date)
//        
//        // When date changes, update the display label
//        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
//        
//        // Hide the actual date picker (we'll show it on tap)
//        self.datePicker = datePicker
//        
//        // Add tap gesture to show date picker
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
//        dateContainer.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc private func dateChanged(_ sender: UIDatePicker) {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy / MM / dd"
//        dateDisplayLabel.text = formatter.string(from: sender.date)
//        dateDisplayLabel.textColor = .darkText
//    }
//    
//    @objc private func showDatePicker() {
//        guard let datePicker = self.datePicker else { return }
//        
//        // Create an alert controller with the date picker
//        let alertController = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
//        
//        // Add the date picker to the alert
//        datePicker.frame = CGRect(x: 0, y: 0, width: alertController.view.frame.size.width, height: 200)
//        alertController.view.addSubview(datePicker)
//        
//        // Add a "Done" button
//        let doneAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
//            self?.dateChanged(datePicker)
//        }
//        alertController.addAction(doneAction)
//        
//        // Add a "Cancel" button
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//        
//        // Present the date picker
//        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
//    }
//}
//
//class DepartmentCell: UITableViewCell {
//    private let containerView = UIView()
//    private let departmentLabel = UILabel()
//    private let deleteButton = UIButton(type: .system)
//    private var deleteAction: (() -> Void)?
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//    
//    private func setupViews() {
//        selectionStyle = .none
//        backgroundColor = .clear
//        
//        containerView.backgroundColor = .systemGray6
//        containerView.layer.cornerRadius = 20
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(containerView)
//        
//        departmentLabel.font = UIFont.systemFont(ofSize: 16)
//        departmentLabel.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(departmentLabel)
//        
//        deleteButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
//        deleteButton.tintColor = .systemGray2
//        deleteButton.translatesAutoresizingMaskIntoConstraints = false
//        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
//        containerView.addSubview(deleteButton)
//        
//        NSLayoutConstraint.activate([
//            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
//            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            containerView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
//            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
//            
//            departmentLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
//            departmentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
//            departmentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8),
//            
//            deleteButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
//            deleteButton.leadingAnchor.constraint(equalTo: departmentLabel.trailingAnchor, constant: 8),
//            deleteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
//            deleteButton.widthAnchor.constraint(equalToConstant: 24),
//            deleteButton.heightAnchor.constraint(equalToConstant: 24)
//        ])
//    }
//    
//    func configure(with department: String, deleteAction: @escaping () -> Void) {
//        departmentLabel.text = department
//        self.deleteAction = deleteAction
//    }
//    
//    @objc private func deleteButtonTapped() {
//        deleteAction?()
//    }
//}
//
//class ButtonCell: UITableViewCell {
//    private let actionButton = UIButton(type: .system)
//    private var buttonAction: (() -> Void)?
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupViews()
//    }
//    
//    private func setupViews() {
//        selectionStyle = .none
//        backgroundColor = .clear
//        
//        actionButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
//        actionButton.setTitleColor(.systemBlue, for: .normal)
//        actionButton.backgroundColor = .clear
//        actionButton.layer.borderWidth = 1
//        actionButton.layer.borderColor = UIColor.systemBlue.cgColor
//        actionButton.layer.cornerRadius = 20
//        // Draw dashed border
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.strokeColor = UIColor.systemBlue.cgColor
//        shapeLayer.lineWidth = 1
//        shapeLayer.lineDashPattern = [4, 4]
//        
//        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: 40), cornerRadius: 20)
//        shapeLayer.path = path.cgPath
//        shapeLayer.fillColor = nil
//        actionButton.layer.addSublayer(shapeLayer)
//        
//        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        actionButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//        contentView.addSubview(actionButton)
//        
//        NSLayoutConstraint.activate([
//            actionButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
//            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//            actionButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//    }
//    
//    func configure(with title: String, action: @escaping () -> Void) {
//        actionButton.setTitle(title, for: .normal)
//        buttonAction = action
//    }
//    
//    @objc private func buttonTapped() {
//        buttonAction?()
//    }
//} 
