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
    @IBOutlet var signInButton: UIButton!

    let eyeButton: UIButton = .init(type: .custom)
    
    var isValidInputs: Bool {
        guard let email = emailTextField.text, !email.isEmpty else {
            return false
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            return false
        }
        
        return email.isValidEmail() && password.count >= 8
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        eyeButton.tintColor = .gray
        eyeButton.isEnabled = false

        passwordTextField.configureEyeButton(with: eyeButton)

        navigationItem.hidesBackButton = true
    }
    
    
    @IBAction func emailFieldChanged(_ sender: UITextField) {
        signInButton.isEnabled = isValidInputs
    }
    
    
    @IBAction func passwordFieldChanged(_ sender: UITextField) {
        passwordEntered(sender: sender)
        signInButton.isEnabled = isValidInputs
    }

    @objc func passwordEntered(sender: UITextField) {
        if passwordTextField.text?.isEmpty ?? true || passwordTextField.text == "" {
            eyeButton.isEnabled = false
            eyeButton.tintColor = .gray
        } else {
            eyeButton.isEnabled = true
            eyeButton.tintColor = .tintColor
        }
    }

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        Task {
            guard let email = emailTextField.text, let password = passwordTextField.text else {
                return
            }
            let loggedIn = await DataController.shared.login(emailAddress: email, password: password)

            DispatchQueue.main.async {
                if loggedIn {
                    let hospitalOnboarded = UserDefaults.standard.bool(forKey: "isHospitalOnboarded")
                    if hospitalOnboarded {
                        self.performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                    } else {
                        self.performSegue(withIdentifier: "segueShowResetPasswordViewController", sender: nil)
                    }

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
