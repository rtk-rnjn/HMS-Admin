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

    let eyeButton1: UIButton = .init(type: .custom)
    let eyeButton2: UIButton = .init(type: .custom)

    override func viewDidLoad() {
        super.viewDidLoad()
        admin = DataController.shared.admin
        eyeButton1.tintColor = .gray
        eyeButton2.tintColor = .gray
        eyeButton1.isEnabled = false
        eyeButton2.isEnabled = false
        eyeButton1.tag = 10
        configureEyeButton(for: passwordTextField, button: eyeButton1)
        configureEyeButton(for: confirmPasswordTextField, button: eyeButton2)
        passwordTextField.addTarget(self, action: #selector(passwordEntered), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(passwordEnteredForCnfrmPass), for: .editingChanged)

        passwordTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)
            confirmPasswordTextField.addTarget(self, action: #selector(textFieldsChanged), for: .editingChanged)

            signInButton.isEnabled = false
            signInButton.alpha = 0.5 //

        navigationItem.hidesBackButton = true
    }

    @objc func textFieldsChanged() {
        let password = passwordTextField.text ?? ""
        let confirmPassword = confirmPasswordTextField.text ?? ""

        let isValid = password.count >= 8 && confirmPassword.count >= 8 && password == confirmPassword

        signInButton.isEnabled = isValid
        signInButton.alpha = isValid ? 1.0 : 0.7 // Adjusted opacity for better visibility
    }

    @objc func passwordEntered(sender: UITextField) {
        if passwordTextField.text?.isEmpty ?? true || passwordTextField.text == "" {
            eyeButton1.isEnabled = false
            eyeButton1.tintColor = .gray
        } else {
            eyeButton1.isEnabled = true
            eyeButton1.tintColor = .tintColor
        }
    }

    @objc func passwordEnteredForCnfrmPass(sender: UITextField) {
        if confirmPasswordTextField.text?.isEmpty ?? true || confirmPasswordTextField.text == "" {
            eyeButton2.isEnabled = false
            eyeButton2.tintColor = .gray
        } else {
            eyeButton2.isEnabled = true
            eyeButton2.tintColor = .tintColor
        }
    }

    @IBAction func signInTapped(_ sender: UIButton) {
        guard let admin else { fatalError("Didnt Sign In") }

        guard let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            showAlert(message: "Please enter password")
            return
        }

        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return
        }

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

    private func configureEyeButton(for textField: UITextField, button: UIButton) {
        // Create the eye button
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)

        // Create a container view to add padding
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        containerView.addSubview(button)

        // Adjust the button's position within the container view
        button.frame = CGRect(x: -8, y: 0, width: 30, height: 30) // Adds a 10-point margin on the right

        // Set the container view as the right view of the text field
        textField.rightView = containerView
        textField.rightViewMode = .always
        textField.isSecureTextEntry = true // Ensure secure entry initially
    }

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
