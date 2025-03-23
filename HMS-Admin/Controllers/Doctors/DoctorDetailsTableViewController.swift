//
//  DoctorDetailsTableViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 20/03/25.
//

import UIKit

class DoctorDetailsTableViewController: UITableViewController {

    var doctor: Staff?

    @IBOutlet var staffLabel: UILabel!
    @IBOutlet var staffSpecializationLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        staffLabel.text = doctor?.fullName
        staffSpecializationLabel.text = doctor?.specializations.joined(separator: ", ")
    }
}
