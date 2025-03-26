//
//  BillingHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import SwiftUI

class BillingHostingController: UIHostingController<BillingView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: BillingView())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
