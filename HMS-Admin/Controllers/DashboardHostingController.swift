//
//  DashboardHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 19/03/25.
//

import SwiftUI

class DashboardHostingController: UIHostingController<DashboardView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DashboardView())
    }

}
