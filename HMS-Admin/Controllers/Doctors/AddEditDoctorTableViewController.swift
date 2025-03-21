//
//  AddEditDoctorTableViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 21/03/25.
//

import UIKit

class AddEditDoctorTableViewController: UITableViewController {
    var doctor: Staff?
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var licenceNumberField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameField.text = doctor?.firstName
        lastNameField.text = doctor?.lastName
        emailField.text = doctor?.emailAddress
        licenceNumberField.text = doctor?.licenseId
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Discard Changes?", message: "Are you sure you want to discard changes?", preferredStyle: .actionSheet)
        let discardAction = UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(discardAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        guard let firstName = firstNameField.text, let lastName = lastNameField.text, let email = emailField.text, let licenseNumber = licenceNumberField.text else {
            return
        }
        if doctor == nil {
            let newDoctor = Staff(firstName: firstName, emailAddress: email, password: "\(firstName)\(firstName.count)", contactNumber: "", specializations: [], department: "", licenseId: licenseNumber)
            Task {
                let success = await DataController.shared.createDoctor(newDoctor)
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            doctor?.firstName = firstName
            doctor?.lastName = lastName
            doctor?.emailAddress = email
            doctor?.licenseId = licenseNumber
            Task {
                let success = await DataController.shared.updateDoctor(doctor!)
                if success {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

}
