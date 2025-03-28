//
//  DashboardHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import SwiftUI
import UIKit

class DashboardHostingController: UIHostingController<DashboardView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DashboardView())
        self.rootView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up tab bar item
        self.tabBarItem = UITabBarItem(
            title: "Dashboard",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        // Configure navigation bar
        navigationItem.title = "Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
