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

    override func viewDidLoad() {
        super.viewDidLoad()
        admin = DataController.shared.admin

        navigationItem.hidesBackButton = true
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
                    self.performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                }
            }
        }
    }

    // MARK: Private

    private func showAlert(message: String) {
        let alert = Utils.getAlert(title: "Error", message: message)
        present(alert, animated: true, completion: nil)
    }
}
