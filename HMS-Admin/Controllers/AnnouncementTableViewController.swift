//
//  AnnouncementTableViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 28/03/25.
//

import UIKit

class AnnouncementTableViewController: UITableViewController {


    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var recieverSegmentedControl: UISegmentedControl!


    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        let title = titleTextField.text ?? ""
        let message = messageTextField.text ?? ""

        let announcement = Announcement(title: title, body: message)

        Task {
            _ = await DataController.shared.createAnnouncement(announcement)
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                Utils.createNotification(title: title, body: message)
            }
        }
    }
}
