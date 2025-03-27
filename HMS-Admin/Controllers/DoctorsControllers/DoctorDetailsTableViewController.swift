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

        updateUI()
    }

    @IBAction func trashButtonTapped(_ sender: UIBarButtonItem) {

        guard let doctor else { return }

        let deleteAction = AlertActionHandler(title: "Delete", style: .destructive) {
            _ in
            Task {
                _ = await DataController.shared.deleteDoctor(doctor)
                DispatchQueue.main.async {
                    self.doctor = nil
                    self.updateUI()
                }
            }
        }
        let cancelAction = AlertActionHandler(title: "Cancel", style: .cancel, handler: nil)

        let alert = Utils.getAlert(title: "Alert", message: "Are you sure you want to delete this doctor?", actions: [cancelAction, deleteAction])
        present(alert, animated: true)
    }

    private func updateUI() {
        staffLabel.text = doctor?.fullName ?? "Doctor Not Found"
        staffSpecializationLabel.text = doctor?.specializations.joined(separator: ", ") ?? "Specialization Not Found"
    }
}
