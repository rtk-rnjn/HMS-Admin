//
//  ResetPasswordViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 20/03/25.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    var admin: Admin?

    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
    }

    @IBAction func signInTapped(_ sender: UIButton) {
        guard let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text else {
            return
        }

        guard password == confirmPassword else {
            return
        }

        admin?.password = password
        guard let admin else { return }

        Task {
            let updated = await DataController.shared.updateAdmin(admin)
            if updated {
                performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
            }
        }
    }
}
