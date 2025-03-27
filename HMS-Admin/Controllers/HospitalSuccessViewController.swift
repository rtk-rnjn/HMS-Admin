//
//  HospitalSuccessViewController.swift
//  HMS-Admin
//
//  Created by Suryansh Srivastav on 28/03/25.
//

import UIKit
import SwiftUI

class HospitalSuccessViewController: UIViewController {
    
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var successTitleLabel: UILabel!
    @IBOutlet weak var hospitalNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contactNumberLabel : UILabel!
    @IBOutlet weak var licenseNumberLabel: UILabel!
    @IBOutlet weak var viewProfileButton: UIButton!
    @IBOutlet weak var addDoctorButton: UIButton!
    
    var hospitalName: String = ""
    var address: String = ""
    var contactNumber: String = ""
    var licenseNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure UI
        setupUI()
        updateLabels()
        
        // Hide the navigation bar for this screen
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar again when leaving this screen
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupUI() {
        // Set image
        successImageView.image = UIImage(systemName: "checkmark.circle.fill")
        successImageView.tintColor = UIColor.systemGreen
        
        // Set labels
        successTitleLabel.text = "Hospital Added Successfully!"
        
        // Configure buttons
        viewProfileButton.backgroundColor = UIColor.systemBlue
        viewProfileButton.setTitleColor(.white, for: .normal)
        viewProfileButton.layer.cornerRadius = 8
        viewProfileButton.setTitle("Home", for: .normal)
        
        addDoctorButton.layer.borderWidth = 1
        addDoctorButton.layer.borderColor = UIColor.systemBlue.cgColor
        addDoctorButton.setTitleColor(.systemBlue, for: .normal)
        addDoctorButton.layer.cornerRadius = 8
        addDoctorButton.setTitle("Add Doctor", for: .normal)
    }
    
    private func updateLabels() {
        hospitalNameLabel.text = hospitalName
        addressLabel.text = address
        contactNumberLabel.text = "Contact Number :  \(contactNumber)"
        licenseNumberLabel.text = "License: \(licenseNumber)"
    }
    
    @IBAction func viewProfileButtonTapped(_ sender: UIButton) {
        // Create a tab bar controller and set the Profile tab (index 3) as the selected tab
        performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
    }
    
    @IBAction func addDoctorButtonTapped(_ sender: UIButton) {
        // Create and show Add Doctor view directly
        let addDoctorView = AddDoctorView()
        let addDoctorVC = UIHostingController(rootView: addDoctorView)
        
        // Present with fullscreen style
        addDoctorVC.modalPresentationStyle = .fullScreen
        present(addDoctorVC, animated: true)
    }
} 
