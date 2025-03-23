//
//  SignInViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import UIKit

class SignInViewController: UIViewController {

    // MARK: Internal

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        Task {
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                return
            }
            let loggedIn = await DataController.shared.login(emailAddress: email, password: password)

            DispatchQueue.main.async {
                if loggedIn {
                    self.performSegue(withIdentifier: "segueShowResetPasswordViewController", sender: nil)
                } else {
                    self.showAlert(message: "Invalid email or password")
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
