//
//  AddDoctorHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import Foundation
import SwiftUI

class AddDoctorHostingController: UIHostingController<AddDoctorView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: AddDoctorView())
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
    }

    // MARK: Private

    private var searchController: UISearchController = .init()

}
