//
//  BillingHostingController.swift
//  HMS-Admin
//
//  Created by RITIK RANJAN on 27/03/25.
//

import SwiftUI

class BillingHostingController: UIHostingController<BillingView> {

    // MARK: Lifecycle

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: BillingView())
    }

    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            // TODO: Fetch Invoice
            self.rootView.invoices = []
        }
    }
}
