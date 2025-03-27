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

    @IBAction func completeButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
    }
}
