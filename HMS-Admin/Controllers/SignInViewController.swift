//
//  SignInViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueShowResetPasswordViewController", let resetPasswordViewController = segue.destination as? ResetPasswordViewController {
            resetPasswordViewController.admin = sender as? Admin
        }
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        Task {
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                return
            }
            guard let admin = await DataController.shared.fetchAdmin(email: email, password: password) else {
                return
            }

            performSegue(withIdentifier: "segueShowResetPasswordViewController", sender: admin)
        }
    }

}
