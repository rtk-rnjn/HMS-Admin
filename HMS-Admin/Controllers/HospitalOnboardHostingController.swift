//
//  HospitalOnboardHostingController.swift
//  HMS-Admin
//
//  Created by Suryansh Srivastav on 27/03/25.
//

import SwiftUI
@_exported import UIKit

class HospitalOnboardHostingController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHospitalOnboardView()
        print("HospitalOnboardHostingController viewDidLoad")
    }
    
    private func setupHospitalOnboardView() {
        let hospitalView = HospitalOnboardView(onSetupCompleted: { [weak self] in
            self?.performSegue(withIdentifier: "segueShowInitialTabBarController", sender: nil)
        })
        
        let hostingController = UIHostingController(rootView: hospitalView)
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
