//
//  ResetPasswordViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 20/03/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    // MARK: Internal

    var admin: Admin?

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var signInButton: UIButton!

    let newPasswordEyeButton: UIButton = .init(type: .custom)
    let confirmPasswordEyeButton: UIButton = .init(type: .custom)
    
    var isValidInputs: Bool {
        guard let password = passwordTextField.text, !password.isEmpty else {
            return false
        }
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            return false
        }
        
        return password == confirmPassword
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        admin = DataController.shared.admin
        newPasswordEyeButton.tintColor = .gray
        confirmPasswordEyeButton.tintColor = .gray
        newPasswordEyeButton.isEnabled = false
        confirmPasswordEyeButton.isEnabled = false
        
        newPasswordEyeButton.tag = 10
    
        passwordTextField.configureEyeButton(with: newPasswordEyeButton)
        confirmPasswordTextField.configureEyeButton(with: confirmPasswordEyeButton)

        navigationItem.hidesBackButton = true
    }

    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        signInButton.isEnabled = isValidInputs
    }

    @IBAction func signInTapped(_ sender: UIButton) {
        guard let admin else { fatalError("Didnt Sign In") }
        
        guard let password = passwordTextField.text else { return }

        if !password.isValidPassword() {
            showAlert(message: "Password must be at least 8 characters long & must contain one uppercase letter, one lowercase letter, and one digit")
        }

        if password == admin.password {
            showAlert(message: "New password cannot be same as old password")
            return
        }

        Task {
            let updated = await DataController.shared.changePassword(oldPassword: admin.password, newPassword: password)

            if updated {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueShowHospitalDetailHostingController", sender: nil)
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                }
            }
        }
    }

    // MARK: Private

    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.tag == 10 {
            passwordTextField.isSecureTextEntry.toggle()
        } else {
            confirmPasswordTextField.isSecureTextEntry.toggle()
        }
    }

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
