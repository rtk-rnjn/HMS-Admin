//
//  SignInViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import UIKit

class SignInViewController: UIViewController {

    @IBAction func signInButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
    }
}
