//
//  DoctorsViewController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import UIKit
import SwiftUI

// This is a simple wrapper class to maintain compatibility with existing code
// Eventually, this can be removed as you transition fully to SwiftUI
class DoctorsViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet var tableView: UITableView!
    var doctors: [Staff]? = []

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's background color
        self.view.backgroundColor = UIColor.systemGroupedBackground
        
        // Create and configure SwiftUI view
        let doctorListView = DoctorListView()
        let hostingController = UIHostingController(rootView: doctorListView)
        
        // Configure the hosting controller
        hostingController.view.backgroundColor = UIColor.systemGroupedBackground
        
        // Add as child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Configure constraints to cover the entire screen
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
        
        // Hide navigation bar since SwiftUI is handling it
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar when this view appears
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Only show the navigation bar when leaving this view if needed by the next screen
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // Simple method to support existing segues if needed
    @IBAction func unwind(_ segue: UIStoryboardSegue) {}
}
