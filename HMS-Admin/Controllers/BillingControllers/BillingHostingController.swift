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
            guard let bills = await DataController.shared.fetchBills() else {
                return
            }
            DispatchQueue.main.async {
                self.rootView.invoices = bills
            }
        }
    }
}
