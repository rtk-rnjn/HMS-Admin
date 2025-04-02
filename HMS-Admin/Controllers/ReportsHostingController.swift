//
//  ReportsHostingController.swift
//  HMS-Admin
//
//  Created by Claude on 28/04/25.
//

import UIKit
import SwiftUI

class ReportsHostingController: UIHostingController<ReportsView> {
    
    // MARK: Lifecycle
    
    init() {
        let reportsView = ReportsView()
        super.init(rootView: reportsView)
        
        // Configure controller appearance
        self.title = "Reports"
        self.modalPresentationStyle = .fullScreen
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
} 