//
//  HospitalOnBoardTableViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 26/03/25.
//

import UIKit

class HospitalOnBoardTableViewController: UITableViewController {
    @IBOutlet var hospitalNameTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var contactTextField: UITextField!
    @IBOutlet var licenseNumberTextField: UITextField!

    @IBOutlet var completeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTextField.tag = 1
        licenseNumberTextField.tag = 2
        setupTextFields()
        setupButton()
        
        // Set title
        self.title = "Hospital OnBoarding"
        
       
    }
    
    private func setupTextFields() {
      contactTextField.keyboardType = .numberPad
        
        // Add validation on editing
        hospitalNameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        contactTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        licenseNumberTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    private func setupButton() {
        completeButton.isEnabled = false
        completeButton.alpha = 0.5
    }
    
    @objc func textFieldChanged(sender:UITextField) {
        
        if sender.tag == 1 {
            let text = sender.text!.last
            if text!.asciiValue! > 57 || text!.asciiValue! < 48 {
                sender.text!.removeLast()
            }
        }
        validateForm()
    }
    
    private func validateForm() {
        let isHospitalNameValid = !(hospitalNameTextField.text?.isEmpty ?? true)
        let isLocationValid = !(addressTextField.text?.isEmpty ?? true)
        
        let isPinCodeValid = validatePinCode()
        let isLicenseNumberValid = !(licenseNumberTextField.text?.isEmpty ?? true)
        
        let isFormValid = isHospitalNameValid && isLocationValid && isPinCodeValid && isLicenseNumberValid
        
        completeButton.isEnabled = isFormValid
        completeButton.alpha = isFormValid ? 1.0 : 0.5
    }
    
    private func validatePinCode() -> Bool {
        guard let contactNumber = contactTextField.text, !contactNumber.isEmpty else {
            return false
        }
        
        // Check if phone number is exactly 10 digits
        let numericOnly = contactNumber.filter { $0.isNumber }
        let isValid = numericOnly.count == 10
        
        if !isValid {
            // Keep only numbers and limit to 10 digits
            contactTextField.text = String(numericOnly.prefix(10))
        }
        
        return isValid
    }
    
    private func saveHospitalInfo() {
        // Save hospital information to data model
        // Example:
        let hospital = Hospital(
            name: hospitalNameTextField.text ?? "",
            address: addressTextField.text,
            contact: contactTextField.text,
            adminId: DataController.shared.admin?.id ?? ""
        )
        
        // Save to data controller
        // DataController.shared.saveHospitalInfo(hospital)
        
        print("Hospital saved: \(hospital.name)")
    }

    @IBAction func completeButtonTapped(_ sender: UIButton) {
        if validatePinCode() {
            saveHospitalInfo()
            
            // Present hospital success screen
            let storyboard = UIStoryboard(name: "HospitalSuccess", bundle: nil)
            if let successVC = storyboard.instantiateInitialViewController() as? HospitalSuccessViewController {
                // Pass hospital information
                successVC.hospitalName = hospitalNameTextField.text ?? ""
                successVC.address = addressTextField.text ?? ""
                successVC.contactNumber = contactTextField.text ?? ""
                successVC.licenseNumber = licenseNumberTextField.text ?? ""
                
                // Present modally with fullscreen style
                successVC.modalPresentationStyle = .fullScreen
                present(successVC, animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Invalid Phone Number", message: "Please enter a valid 10-digit phone number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowInitialTabBarController" {
            // Any setup needed before showing the tab bar controller
        }
    }
}
