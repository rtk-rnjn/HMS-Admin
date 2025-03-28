//
//  ProfileHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 28/03/25.
//

import SwiftUI

class ProfileHostingController: UIHostingController<AdminProfileView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AdminProfileView())
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
    }
}
